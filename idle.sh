#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
keyboardbrightness=$(cat /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness)

set -ue -o pipefail
safe_source () { [[ ! -z ${1:-} ]] && source $1; _dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; _sdir=$(dirname "$(readlink -f "$0")"); }; safe_source

_idleAfter=$1
[[ $(echo $_idleAfter | awk -F":" '{print NF-1}') -ne 2 ]] && { \
    exit 1; }
idleAfter=$(echo $_idleAfter | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')


idle=false
idleAfterMs=$(($idleAfter * 1000))
shift

function format_seconds() {
  (($1 >= 86400)) && printf '%d days and ' $(($1 / 86400)) # days
  (($1 >= 3600)) && printf '%02d:' $(($1 / 3600 % 24))     # hours
  (($1 >= 60)) && printf '%02d:' $(($1 / 60 % 60))         # minutes
  printf '%02d%s\n' $(($1 % 60)) "$( (($1 < 60 )) && echo ' s.' || echo '')"
}

exe_pid=
cleanup(){
    [[ -n $exe_pid ]] && { kill $exe_pid 2> /dev/null || true; }
}

trap cleanup EXIT

IDLE_EXE=$_sdir/idle

while :; do
    $IDLE_EXE > /dev/null \
        && break \
        || { \
            sleep 5; \
           }
done
pollInterval=0.1
idleBase=0
idleTimeMsNew=
while true; do
  keyboardbrightnessmod=$(cat /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness)
  if [ "$keyboardbrightness" != "$keyboardbrightnessmod" ] && [ "$keyboardbrightnessmod" != "0" ]; then
    keyboardbrightness=$keyboardbrightnessmod; 
  fi  
  idleTimeMsNew=$($IDLE_EXE)
  if [[ -n ${idleTimeMs:-} ]]; then 
    if [[ $idleTimeMsNew -lt $idleTimeMs ]]; then
      testDuration="0.1"; testDurationMs="100";
      sleep $testDuration
      testIdleMs=$($IDLE_EXE)
      testDiff=$(($testIdleMs - $testDurationMs - $idleTimeMsNew))
      if [[ $testDiff -gt 0 ]]; then 
        idleBase=$(($idleBase + $idleTimeMs))
      else
        idleBase=0
      fi
    fi 
  fi 
  idleTimeMs=$idleTimeMsNew
  if [[ $idle = false && $(($idleTimeMs + $idleBase)) -gt $idleAfterMs ]] ; then
    idle=true
    echo "0" > /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness
    if [[ -n $exe_pid ]]; then
	    echo ""
    else
      "$@" & exe_pid=$!
    fi
  fi

  if [[ $idle = true && $(($idleTimeMs + $idleBase)) -lt $idleAfterMs ]] ; then
    if kill -0 $exe_pid 2> /dev/null; then
        echo $keyboardbrightness > /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness
        kill $exe_pid
        timeout 5 tail --pid=$exe_pid -f /dev/null || true
    else
        echo $keyboardbrightness > /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness
    fi
    idle=false
    idleBase=0
  fi

  if ! kill -s 0 $exe_pid 2> /dev/null; then
    exe_pid=
  fi
  sleep $pollInterval
done

