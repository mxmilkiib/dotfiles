#!/bin/bash
ARGS=$*
DESKARRAY=`i3-msg -t get_workspaces | jq -r '[.[] | select(.num) | .num ] | @csv'`
DESKCURRENT=`i3-msg -t get_workspaces | jq -r '.[] | select(.visible and .focused) | .num'`
# OUTPUTID==${DESKCURRENT:0:1}
# echo $ARGS
# echo $DESKARRAY
# echo $DESKCURRENT
# echo OUTPUTID
while [[ $DESKARRAY = *$DESKCURRENT* ]]; do
  DESKCURRENT=$((DESKCURRENT+1));
# echo $DESKCURRENT
done
~/bin/i3/i3-multimon.sh 'move workspace $ws'$DESKCURRENT', workspace next' &> /dev/null
