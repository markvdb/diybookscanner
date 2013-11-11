#! /bin/bash

LANG=C
TMOUT=15
TMOUT2=2

CHDKPTP='/home/pi/camera2/script.sh'
CAM1_USBBUS=''
CAM1_USBID=''
CAM1_ORIENTATION=''
CAM2_USBBUS=''
CAM2_USBID=''
CAM2_ORIENTATION=''

#TODO ZOOMLEVEL=3
#TODO ISO=50
#TODO experiment with dng versus jpg quality, speed, reliability

function detect_cams {
  CAMS=$($CHDKPTP -elist)
  CAM1_USBBUS=$($CHDKPTP -elist|head -n1| cut -f4 -d' '| sed -e 's/b\=//g')
  CAM1_USBID=$($CHDKPTP -elist|head -n1| cut -f5 -d' '| sed -e 's/d\=//g')
  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'download orientation.txt /tmp'
  CAM1_ORIENTATION=$(cat /tmp/orientation.txt)
  rm -rf /tmp/orientation.txt
  # TODO orientation
  CAM2_USBBUS=$($CHDKPTP -elist|tail -n1| cut -f4 -d' '| sed -e 's/b\=//g')
  CAM2_USBID=$($CHDKPTP -elist|tail -n1| cut -f5 -d' '| sed -e 's/d\=//g')
  # TODO orientation
  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e'download orientation.txt /tmp'
  CAM2_ORIENTATION=$(cat /tmp/orientation.txt)
  rm -rf /tmp/orientation.txt
  echo $CAM1_USBBUS $CAM1_USBID $CAM1_ORIENTATION
  echo $CAM2_USBBUS $CAM2_USBID $CAM2_ORIENTATION
}

function switch_to_record_mode {
  echo "Switching cameras to record mode..."
  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -erec
  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -erec
}

function set_flash {
  echo "Switching flash off..."
  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua while(get_flash_mode()<2) do click("right") end'
  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e'lua while(get_flash_mode()<2) do click("right") end'
}

function set_iso {
  echo "Setting camera 1 iso..."
  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua set_iso_real(50)'
  echo "Setting camera 2 iso..."
  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e'lua set_iso_real(50)'
}

function set_ndfilter {
  echo "Setting camera 1 nd filter off..."
  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua set_nd_filter(2)'
  echo "Setting camera 2 nd filter off..."
  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e'lua set_nd_filter(2))'
}

function set_zoom {
  echo "Setting camera 1 zoom..."
  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua while(get_zoom()<3) do click("zoom_in") end'
  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua while(get_zoom()>3) do click("zoom_out") end'
  echo "Setting camera 2 zoom..."
  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e'lua while(get_zoom()<3) do click("zoom_in") end'
  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e'lua while(get_zoom()>3) do click("zoom_out") end'
  sleep 3s
}

detect_cams
switch_to_record_mode
set_zoom
set_flash
set_iso
set_ndfilter


$CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua play_sound(0)'
while true
do
echo "In outer foot pedal loop.\n
  Press once to start scanning a new book.\n
  Press Ctrl-C to stop the scanning loop."
  read -n1 press1
  if [ "$press1" == "b" ]; then
echo "Pedal pressed first time."
    read -n1 -t$TMOUT2 press2
    if [ -z "$press2" ]; then
      # Shooting loop
      echo "Pedal pressed once in two seconds. Starting shooting loop..."
      $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua play_sound(0)'
      while true; do
        # watch foot pedal if it is pressed
        read -n1 shoot
        if [ "$shoot" == "b" ]; then
         echo "Key pressed."
         echo "Shooting with cameras left and right"
         # TODO: try to make safely switching cameras faster: chdkptp with multicam module? lua tricks? (multiple seconds wait between triggering cams necessary now)
         # shutter speed needs to be set before every shot
         set_iso
         $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e"luar set_tv96(320)"
         $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -eremoteshoot
         sleep 2s
         # shutter speed needs to be set before every shot
         $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e"luar set_tv96(320)"
         $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -eremoteshoot
         sleep 2s
        elif [ -z "$shoot" ]; then
         echo "Foot pedal not pressed for $TMOUT seconds. Falling back to outer foot pedal loop."
          break
fi
done # end shooting loop
    elif [ "$press2" == "b" ]; then
echo "Pedal pressed twice in two seconds. Downloading and deleting from cameras."
    fi
fi
done
