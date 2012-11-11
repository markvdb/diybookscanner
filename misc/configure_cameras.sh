#! /bin/bash
# Camera configuration script for Canon PowerShot cameras.
# Sets the orientation in the camera's internal settings storage.
# TODO preconfigure autofocus lock and/or macro mode.

LANG=C

#Preparations
echo "Please note that this camera configuration script has been tested and confirmed to work on Ubuntu 11.04, 12.04 and 12.10. For some yet unknown reason, gphoto2 flips on Debian. You have been warned!"
echo "Before proceeding, please stick a label 'left' to one camera and a label 'right' to the other. Make sure that the cameras are properly mounted to the scanner. Press eany key when done."
read -n1 response

for orientation in left right; do {
  echo "Please connect the camera labeled \"$orientation\". Make sure it is not in use in any other way (auto mounting, ...). Press any key when ready."
  read -n1 response
  echo "Configuring camera orientation setting."
  CAM=$(gphoto2 --auto-detect|grep usb|sed -e 's/.*\(usb*\)/\1/g'|head -n1)
  gphoto2 --port $CAM --set-config /main/settings/ownername=$orientation
  OUTPUT=$(gphoto2 --port $CAM --get-config /main/settings/ownername|grep $orientation|sed -e "s/.*\($orientation\)/\1/g")
  echo "\"$OUTPUT\" is the orientation set for the camera labeled $orientation."
  echo "Please disconnect the camera labeled \"$orientation\". Press any key when done."
  read -n1 response
  }
done
