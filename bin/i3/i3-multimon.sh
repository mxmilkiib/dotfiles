#!/bin/bash
ARGS=$*
SWAPOUT="\$ws"
CURRENTDESK=`i3-msg -t get_workspaces | jq -r '.[] | select(.visible and .focused) | .output'`
if [[ $CURRENTDESK = "DVI-I-1" ]];
	then OUTPUTID="1";
elif [[ $CURRENTDESK = "DVI-I-0" ]];
  then OUTPUTID="2";
fi
NEWARGS="${ARGS//\$ws/$OUTPUTID}"
i3-msg $NEWARGS &> /dev/null
