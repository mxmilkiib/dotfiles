#!/bin/sh
count=`ps aux | grep -c $1`
wmm="i3-msg"
if [ `ps aux | grep -c sway` > 1 ]; then wmm="swaymsg"; fi
if [ $count -eq 3 ]; then
    $wmm exec $*
else
  if [ $2 ]; then
    $wmm exec "$*"
    $wmm "[title=(?i)$1] focus"
  else
    $wmm "[title=(?i)$1] focus"
  fi
fi
