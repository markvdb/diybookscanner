#! /bin/bash

LANG=C
TMOUT=15
TMOUT2=2

CHDKPTP='/usr/bin/chdkptp'

declare -A CAM_USBBUS
declare -A CAM_USBID
declare -A CAM_ORIENTATION

CAMS=''

CAM1_USBBUS=''
CAM1_USBID=''
CAM1_ORIENTATION=''
CAM2_USBBUS=''
CAM2_USBID=''
CAM2_ORIENTATION=''

CAMCOUNT=''

#TODO ZOOMLEVEL=3
#TODO ISO=50
#TODO experiment with dng versus jpg quality, speed, reliability

function detect_cams {
  CAMS=$($CHDKPTP -elist)
  CAMCOUNT=$(echo "$CAMS"|wc -l)
  for ((id=1; id<=$CAMCOUNT; id++));do
    echo "In for loop. id= $id"
    CAM_USBBUS[$id]=$($CHDKPTP -elist|sed -n ""$id"p"| cut -f4 -d' '| sed -e 's/b\=//g')
    #echo ${CAM_USBBUS[$id]}
    CAM_USBID[$id]=$($CHDKPTP -elist|sed -n ""$id"p"| cut -f5 -d' '| sed -e 's/d\=//g')
    #echo ${CAM_USBID[$id]}
    $CHDKPTP -e"connect -b=${CAM_USBBUS[$id]} -d=${CAM_USBID[$id]}" -e'download orientation.txt /tmp'
    CAM_ORIENTATION[$id]=$(cat /tmp/orientation.txt)
    rm -rf /tmp/orientation.txt
  done
  echo "CAMERA DETECTED:"
  echo ${CAM_USBBUS[*]} ${CAM_USBID[*]} ${CAM_ORIENTATION[*]}
}

function set_focus {
  CAMS=$($CHDKPTP -elist)
  CAMCOUNT=$(echo "$CAMS"|wc -l)
  for ((id=1; id<=$CAMCOUNT; id++));do
    echo "Setting focus for camera where id= $id"
    CAM_USBBUS[$id]=$($CHDKPTP -elist|sed -n ""$id"p"| cut -f4 -d' '| sed -e 's/b\=//g')
    #echo ${CAM_USBBUS[$id]}
    CAM_USBID[$id]=$($CHDKPTP -elist|sed -n ""$id"p"| cut -f5 -d' '| sed -e 's/d\=//g')
    #echo ${CAM_USBID[$id]}
#$CHDKPTP -e"connect -b=$CAM_USBBUS -d=$CAM_USBID" -e"lua set_focus(300)"

    time $CHDKPTP -e"connect -b=${CAM_USBBUS[$id]} -d=${CAM_USBID[$id]}" -e'lua set_focus(300)'
    time CAM_ORIENTATION[$id]=$(cat /tmp/orientation.txt)
    time rm -rf /tmp/orientation.txt
  done
  echo ${CAM_USBBUS[*]} ${CAM_USBID[*]} ${CAM_ORIENTATION[*]}
}
 
######################################

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

#function set_iso {
#  echo "Setting camera 1 iso..."
#  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua set_iso_real(50)'
#  echo "Setting camera 2 iso..."
#echo $CAM2_USBBUS
#echo $CAM2_USBID
#  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e'lua set_iso_real(50)'
#}

function set_iso_loop {
  CAMS=$($CHDKPTP -elist)
  CAMCOUNT=$(echo "$CAMS"|wc -l)
  for ((id=1; id<=$CAMCOUNT; id++));do
    echo "Setting iso for camera where id= $id"
    CAM_USBBUS[$id]=$($CHDKPTP -elist|sed -n ""$id"p"| cut -f4 -d' '| sed -e 's/b\=//g')
    #echo ${CAM_USBBUS[$id]}
    CAM_USBID[$id]=$($CHDKPTP -elist|sed -n ""$id"p"| cut -f5 -d' '| sed -e 's/d\=//g')
    #echo ${CAM_USBID[$id]}
#$CHDKPTP -e"connect -b=$CAM_USBBUS -d=$CAM_USBID" -e"lua set_focus(300)"

    time $CHDKPTP -e"connect -b=${CAM_USBBUS[$id]} -d=${CAM_USBID[$id]}" -e'lua set_iso_real(50)'
  done
  echo ${CAM_USBBUS[*]} ${CAM_USBID[*]} ${CAM_ORIENTATION[*]}
}
 
function set_flash_loop {
  CAMS=$($CHDKPTP -elist)
  CAMCOUNT=$(echo "$CAMS"|wc -l)
  for ((id=1; id<=$CAMCOUNT; id++));do
    echo "Setting flash for camera where id= $id"
    CAM_USBBUS[$id]=$($CHDKPTP -elist|sed -n ""$id"p"| cut -f4 -d' '| sed -e 's/b\=//g')
    #echo ${CAM_USBBUS[$id]}
    CAM_USBID[$id]=$($CHDKPTP -elist|sed -n ""$id"p"| cut -f5 -d' '| sed -e 's/d\=//g')
    #echo ${CAM_USBID[$id]}
#$CHDKPTP -e"connect -b=$CAM_USBBUS -d=$CAM_USBID" -e"lua set_focus(300)"
 
    time $CHDKPTP -e"connect -b=${CAM_USBBUS[$id]} -d=${CAM_USBID[$id]}" -e'lua while(get_flash_mode()<2) do click("right") end'
  done
  echo ${CAM_USBBUS[*]} ${CAM_USBID[*]} ${CAM_ORIENTATION[*]}
}


function set_ndfilter {
  echo "Setting camera 1 nd filter off..."
  $CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua set_nd_filter(2)'
  echo "Setting camera 2 nd filter off..."
  $CHDKPTP -e"connect -b=$CAM2_USBBUS -d=$CAM2_USBID" -e'lua set_nd_filter(2)'
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

function shoot_cam {
  echo "CAM_USBBUS CAM_USBID CAM_ORIENTATION ${CAM_USBBUS[*]} ${CAM_USBID[*]} ${CAM_ORIENTATION[*]}"
  echo "$1 is dollar een"
  id=$1
  $CHDKPTP -e"connect -b=${CAM_USBBUS[$id]} -d=${CAM_USBID[$id]}" -e"luar set_tv96(320)"
  $CHDKPTP -e"connect -b=${CAM_USBBUS[$id]} -d=${CAM_USBID[$id]}" -eremoteshoot
}

detect_cams
switch_to_record_mode
set_zoom
set_flash_loop
set_iso_loop
set_ndfilter
#set_focus

$CHDKPTP -e"connect -b=$CAM1_USBBUS -d=$CAM1_USBID" -e'lua play_sound(0)'
while true
do
echo "In outer foot pedal loop. Press once for shooting, twice for downloading and deleting from cameras."
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
         #set_iso
#  echo "CAM_USBBUS CAM_USBID CAM_ORIENTATION ${CAM_USBBUS[*]} ${CAM_USBID[*]} ${CAM_ORIENTATION[*]}"
	shoot_cam 2 
	shoot_cam 1 
        elif [ -z "$shoot" ]; then
         echo "Foot pedal not pressed for $TMOUT seconds. Falling back to outer foot pedal loop."
          break
fi
done # end shooting loop
    elif [ "$press2" == "b" ]; then
echo "Pedal pressed twice in two seconds. Downloading and deleting from cameras."
      download_from_cams
      delete_from_cams
      echo "Dowloaded and deleted from cameras. Back to beginning of outer loop."
    fi
fi
done
