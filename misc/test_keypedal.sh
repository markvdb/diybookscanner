#! /bin/bash

TMOUT=10
PTPCAM='/usr/src/ptpcam/ptpcam'

GPHOTOCAM1=$(gphoto2 --auto-detect|grep usb|sed -e 's/.*Camera *//g'|head -n1)
GPHOTOCAM2=$(gphoto2 --auto-detect|grep usb|sed -e 's/.*Camera *//g'|tail -n1)

CAM1=$(echo $GPHOTOCAM1|sed -e 's/.*,//g')
CAM2=$(echo $GPHOTOCAM2|sed -e 's/.*,//g')

echo "Found cameras: $GPHOTOCAM1 $GPHOTOCAM2"

echo "$GPHOTOCAM1: deleting existing images from SD card"
gphoto2 --port $GPHOTOCAM1 --recurse -D A/store00010001/DCIM/
echo "$GPHOTOCAM2: deleting existing images from SD card"
gphoto2 --port $GPHOTOCAM2 --recurse -D A/store00010001/DCIM/

echo "Switching cameras to record mode..."
$PTPCAM --dev=$CAM1 --chdk='mode 1'
$PTPCAM --dev=$CAM2 --chdk='mode 1'

echo "Starting foot pedal loop..."
while true
do
  read -n1 shoot
  if [ -z "$shoot" ]; then
    echo "Foot pedal not pressed for $TMOUT seconds. Downloading images and deleting from cameras..."
    echo "Downloading images from $CAM1"
    # gphoto2 processes end with -1 unexpected result even though everything seems to be fine
    gphoto2 --port $GPHOTOCAM1 -P A/store_00010001/DCIM/100___01gphoto2 --port $GPHOTOCAM1 --recurse -D A/store00010001/DCIM/
    RETVAL = $?
    # wait for gphoto2 download process to finish
    [ $RETVAL -eq -1 ] && gphoto2 --port $GPHOTOCAM1 --recurse -D A/store00010001/DCIM/
    echo "Downloading images from $CAM2"
    gphoto2 --port $GPHOTOCAM2 -P A/store_00010001/DCIM/100___01
    RETVAL = $?
    [ $RETVAL -eq -1 ] && gphoto2 --port $GPHOTOCAM2 --recurse -D A/store00010001/DCIM/
  else
    echo "Key pressed."
    echo "Shooting with camera $CAM1"
    $PTPCAM --dev=$CAM1 --chdk='lua shoot()'
    echo "Shooting with camera $CAM2"
    $PTPCAM --dev=$CAM2 --chdk='lua shoot()'
  fi
done


