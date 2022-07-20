### TUXEDO Keyboard Tools

A project created to add a timeout to the one-way keyboard illumination for TUXEDO and TUXEDO clone systems.

If you want to start this application on your system, first compile it (run build.sh). To run the service, enter these commands and restart your machine:
systemctl --user enable tuxedo-keyboard-idle.service

The timeout is 15 seconds by default. If you want to change it, it is enough to write a minus of how many seconds you will set 0:0:14 in the tuxedo-keyboard-idle.service file. For example, if you are going to do it for 1 minute, you need to do 0:0:59, if you are going to do it for one and a half minutes, you need to do 0:1:29.

If you want, you can also run tuxedo-keyboard-keep-light.service system-wide and keep the keyboard at whatever level it was last on the next startup. To run this too, enter these codes:
sudo systemctl enable tuxedo-keyboard-keep-light-level.service

https://user-images.githubusercontent.com/47495526/180011264-d63f1620-bb16-4557-bce2-858a98038edf.mp4
