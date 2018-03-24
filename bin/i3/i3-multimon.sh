#!/bin/bash
ARGS=$*
SWAPOUT="\$o"
CURRENTDESKOUTPUT=`i3-msg -t get_workspaces | jq -r '.[] | select(.visible and .focused) | .output'`
if [[ $CURRENTDESKOUTPUT = "DVI-I-1" ]];
	then OUTPUTID="1";
elif [[ $CURRENTDESKOUTPUT = LVDS* ]];
  then OUTPUTID="1";
elif [[ $CURRENTDESKOUTPUT = "DVI-I-0" ]];
  then OUTPUTID="2";
fi
NEWARGS="${ARGS//\$o/$OUTPUTID}"
i3-msg $NEWARGS &> /dev/null
