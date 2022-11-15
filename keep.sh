#!/bin/sh

myfile=$(grep -lr "options tuxedo-keyboard" /etc/modprobe.d)
configbrightnesslevel=$(cat $myfile | sed -n 's/.*brightness=\([^ ]*\).*/\1/p')
keepbrightnesslevel="$(cat /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness)"
sed -i "s/brightness=$configbrightnesslevel/brightness=$keepbrightnesslevel/g" $myfile
