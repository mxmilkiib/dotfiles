#!/bin/bash
ARGS=$*
DESKOUTPUT=`swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name"`
DESKNAMES=`swaymsg -t get_workspaces | jq -r --arg DESKOUTPUT "$DESKOUTPUT" '.[] | select(.output==$DESKOUTPUT) | .name' | sed -e 's/^.*://'`
DESKCURRENT=`swaymsg -t get_workspaces | jq -r '.[] | select(.visible and .focused) | .num'`

for i in {1..9}
do
  if [[ $DESKNAMES != *$i* ]]; then swaymsg move window to workspace $i; swaymsg workspace $i; break; fi
done
