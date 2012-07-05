#! /bin/bash

LANG=C
TMOUT=10
PTPCAM='/usr/bin/ptpcam'

function detect_cams {
  CAMS=$(gphoto2 --auto-detect|grep usb| wc -l)
  if [ $CAMS -eq 2 ]; then
    GPHOTOCAM1=$(gphoto2 --auto-detect|grep usb|sed -e 's/.*Camera *//g'|head -n1)
    GPHOTOCAM2=$(gphoto2 --auto-detect|grep usb|sed -e 's/.*Camera *//g'|tail -n1)
    CAM1=$(echo $GPHOTOCAM1|sed -e 's/.*,//g')
    CAM2=$(echo $GPHOTOCAM2|sed -e 's/.*,//g')
    echo "Detected 2 camera devices: $GPHOTOCAM1 and $GPHOTOCAM2"
  else
    echo "Number of camera devices does not equal 2. Giving up."
    exit
  fi
}

function delete_from_cams {
  echo "$GPHOTOCAM1: deleting existing images from SD card"
  gphoto2 --port $GPHOTOCAM1 --recurse -D A/store00010001/DCIM/; true
  echo "$GPHOTOCAM2: deleting existing images from SD card"
  gphoto2 --port $GPHOTOCAM2 --recurse -D A/store00010001/DCIM/; true
}

function switch_to_record_mode {
  echo "Switching cameras to record mode..."
  echo "$CAM1 is CAM1 and $CAM2 is CAM2"
  $PTPCAM --dev=$CAM1 --chdk='mode 1' > /dev/null 2>&1
  $PTPCAM --dev=$CAM2 --chdk='mode 1' > /dev/null 2>&1
}

function download_from_cams {
    echo "Downloading images from $CAM1..."
    # gphoto2 processes end with -1 unexpected result even though everything seems to be fine -> hack: true gives exit status 0
    gphoto2 --port $GPHOTOCAM1 -P A/store_00010001/DCIM/; true
    echo "Downloading images from $CAM2"
    gphoto2 --port $GPHOTOCAM2 -P A/store_00010001/DCIM/; true 
}

detect_cams
# delete_from cams confuses ptpcam -> do that at the end
switch_to_record_mode

echo "Starting foot pedal loop..."
while true
do
  read -n1 shoot
  if [ "$shoot" == "b" ]; then
    echo "Key pressed."
    echo "Shooting with cameras $CAM1 and $CAM2"
    $PTPCAM --dev=$CAM1 --chdk='lua shoot()'
    $PTPCAM --dev=$CAM2 --chdk='lua shoot()'
  elif [ "$shoot" == "q" ]; then
    echo "Quitting without downloading images from cameras!"
    exit
  elif [ -z "$shoot" ]; then
    echo "Foot pedal not pressed for $TMOUT seconds."
    download_from_cams
    delete_from_cams
    echo "Quitting"
    exit 
  fi
done


