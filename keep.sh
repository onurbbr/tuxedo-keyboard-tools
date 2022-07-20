#!/bin/sh

configbrightnesslevel=$(cat /etc/modprobe.d/tuxedo_keyboard.conf | awk '{print $3}' | sed -n -e 's/^brightness=\([0-9]\+\).*/\1/p')
keepbrightnesslevel=$(cat /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness)
sed -i "s/brightness=$configbrightnesslevel/brightness=$keepbrightnesslevel/g" /etc/modprobe.d/tuxedo_keyboard.conf
