#!/bin/sh
count=`ps aux | grep -c $1`
if [ $count -eq 3 ]; then
    i3-msg exec $*
else
  if [ $2 ]; then
    i3-msg exec "$*"
    i3-msg "[instance=$1] focus"
  else
    i3-msg "[instance=$1] focus"
  fi
fi
