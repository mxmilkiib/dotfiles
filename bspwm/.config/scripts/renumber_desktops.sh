#!/bin/bash
# renumber_desktops.sh
# Written by Ethan Li, <lietk12@gmail.com>
# hacked by milk
# Summary: Renumbers all existing workspaces to be densely numbered in
# ascending order from 1 to n, where n is the total number of workspaces.

num_desktops=$(bspc query -D | wc -l)
# desktops=($(bspc query -D))
monitors=$(bspc query -M)

for (( i=1; i<=${num_desktops}; ++i ))
do
  monitor=$(bspc query -M -d "^${i}")
  monitorletter=`echo "$monitors" | grep -n "$monitor" | awk 'BEGIN {FS=":"}{print $1}' | tr "1-2" "A-B"`
  bspc desktop "^${i}" --rename ${monitorletter}${i}
done
