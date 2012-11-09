#! /bin/bash

LANG=C
PTPCAM='/usr/bin/ptpcam'
TMOUT=15
TIMESTAMP=$(date +%Y%m%d%H%M)

function detect_cams {
  CAMS=$(gphoto2 --auto-detect|grep usb| wc -l)
  if [ $CAMS -eq 2 ]; then
    GPHOTOCAM1=$(gphoto2 --auto-detect|grep usb|sed -e 's/.*Camera *//g'|head -n1)
    GPHOTOCAM2=$(gphoto2 --auto-detect|grep usb|sed -e 's/.*Camera *//g'|tail -n1)
    echo $GPHOTOCAM1" is gphotocam1"
    echo $GPHOTOCAM2" is gphotocam2"
    
    GPHOTOCAM1ORIENTATION=$(gphoto2 --port $GPHOTOCAM1 --get-config /main/settings/ownername|grep Current|sed -e's/.*\ //')
    GPHOTOCAM2ORIENTATION=$(gphoto2 --port $GPHOTOCAM2 --get-config /main/settings/ownername|grep Current|sed -e's/.*\ //')

    echo $GPHOTOCAM1ORIENTATION" is gphotocam1orientation"
    echo $GPHOTOCAM2ORIENTATION" is gphotocam2orientation"

    CAM1=$(echo $GPHOTOCAM1|sed -e 's/.*,//g')
    CAM2=$(echo $GPHOTOCAM2|sed -e 's/.*,//g')
    echo "Detected 2 camera devices: $GPHOTOCAM1 and $GPHOTOCAM2"
  else
    echo "Number of camera devices does not equal 2. Giving up."
    exit
  fi
  if [ "$GPHOTOCAM1ORIENTATION" == "left" ]; then
    LEFTCAM=$(echo $GPHOTOCAM1|sed -e 's/.*,//g')
    LEFTCAMLONG=$GPHOTOCAM1
  elif [ "$GPHOTOCAM1ORIENTATION" == "right" ]; then
    RIGHTCAM=$(echo $GPHOTOCAM1| sed -e 's/.*,//g')
    RIGHTCAMLONG=$GPHOTOCAM1
  else
    echo "$GPHOTOCAM1 owner name is neither set to left or right. Please configure that before continuing."
    exit
  fi
  if [ "$GPHOTOCAM2ORIENTATION" == "left" ]; then
    LEFTCAM=$(echo $GPHOTOCAM2|sed -e 's/.*,//g')
    LEFTCAMLONG=$GPHOTOCAM2
  elif [ "$GPHOTOCAM2ORIENTATION" == "right" ]; then
    RIGHTCAM=$(echo $GPHOTOCAM2| sed -e 's/.*,//g')
    RIGHTCAMLONG=$GPHOTOCAM2
  else
    echo "$GPHOTOCAM2 owner name is neither set to left or right. Please configure that before continuing."
    exit
  fi
}

function delete_from_cams {
  $PTPCAM --dev=$LEFTCAM --chdk='lua play_sound(6)'
  echo "$GPHOTOCAM1: deleting existing images from SD card"
  gphoto2 --port $GPHOTOCAM1 --recurse -D A/store00010001/DCIM/; true
  echo "$GPHOTOCAM2: deleting existing images from SD card"
  gphoto2 --port $GPHOTOCAM2 --recurse -D A/store00010001/DCIM/; true
  $PTPCAM --dev=$LEFTCAM --chdk='lua play_sound(0)'
}

function switch_to_record_mode {
  echo "Switching cameras to record mode..."
  echo "$LEFTCAM is LEFTCAM and $RIGHTCAM is RIGHTCAM"
  echo "Switching left camera to record mode and sleeping 1 second..."
  $PTPCAM --dev=$LEFTCAM --chdk='mode 1' > /dev/null 2>&1 && sleep 1s
  echo "Switching right camera to record mode and sleeping 1 second..."
  $PTPCAM --dev=$RIGHTCAM --chdk='mode 1' > /dev/null 2>&1 && sleep 1s
  sleep 3s
}


function set_zoom {
  # TODO: make less naive about zoom setting (check before and after setting, ...)
  echo "Setting cameras zoom to 3..."
  echo "Setting left camera zoom to 3..."
  $PTPCAM --dev=$LEFTCAM --chdk='lua while(get_zoom()<3) do click("zoom_in") end'
  $PTPCAM --dev=$LEFTCAM --chdk='lua while(get_zoom()>3) do click("zoom_out") end'
  echo "Setting right camera zoom to 3..."
  $PTPCAM --dev=$RIGHTCAM --chdk='lua while(get_zoom()<3) do click("zoom_in") end'
  $PTPCAM --dev=$RIGHTCAM --chdk='lua while(get_zoom()>3) do click("zoom_out") end'
  sleep 3s
}

function flash_off {
  echo "Switching flash off..."
  $PTPCAM --dev=$LEFTCAM --chdk='lua while(get_flash_mode()<2) do click("right") end'
  $PTPCAM --dev=$RIGHTCAM --chdk='lua while(get_flash_mode()<2) do click("right") end'
}

function download_from_cams {
    echo "Downloading images from $CAM1..."
    mkdir -p ~/bookscan_$TIMESTAMP/left ~/bookscan_$TIMESTAMP/right
    cd bookscan_$TIMESTAMP/left
    $PTPCAM --dev=$LEFTCAM --chdk='lua play_sound(6)'
    # gphoto2 processes end with -1 unexpected result even though everything seems to be fine -> hack: true gives exit status 0
    gphoto2 --port $LEFTCAMLONG -P A/store_00010001/DCIM/; true
    cd ../right
    echo "Downloading images from $CAM2"
    gphoto2 --port $RIGHTCAMLONG -P A/store_00010001/DCIM/; true 
    cd ..
}

function set_iso {
    echo "Setting ISO mode to 1 for left cam."
    ptpcam --dev=$LEFTCAM --chdk="lua set_iso_mode(1)"
    echo "Setting ISO mode to 1 for right cam."
    ptpcam --dev=$RIGHTCAM --chdk="lua set_iso_mode(1)"
}

# The action starts here

detect_cams
# delete_from cams confuses ptpcam -> do that at the end
switch_to_record_mode
set_zoom
flash_off
set_iso

echo "Starting foot pedal loop..."
$PTPCAM --dev=$LEFTCAM --chdk='lua play_sound(0)'
while true
do
  # watch foot pedal if it is pressed
  read -n1 shoot
  if [ "$shoot" == "b" ]; then
    echo "Key pressed."
    echo "Shooting with cameras $LEFTCAM (left) and $RIGHTCAM (right)"
    # TODO: try to make safely switching cameras faster: chdkptp? lua tricks? (multiple seconds wait between triggering cams necessary now)
    $PTPCAM --dev=$LEFTCAM --chdk='lua shoot()'
    sleep 2s
    $PTPCAM --dev=$RIGHTCAM --chdk='lua shoot()'
    sleep 2s
    #$PTPCAM --dev=$LEFTCAM --chdk='lua play_sound(4)' && sleep 0.5
    #$PTPCAM --dev=$RIGHTCAM --chdk='lua play_sound(4)' && sleep 0.5
  elif [ -z "$shoot" ]; then
    echo "Foot pedal not pressed for $TMOUT seconds."
    download_from_cams
    delete_from_cams
    echo "Quitting"
    exit 
  fi
done


