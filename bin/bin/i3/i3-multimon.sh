#!/bin/bash
ARGS=$*
SWAPOUT="\$o"
if [ `ps aux | grep -c sway` > 1 ]; then wmm="swaymsg"; wms="sway"; else wmm="i3-msg"; wms="i3-msg"; fi
CURRENTDESKOUTPUT=`$wmm -t get_workspaces | jq -r '.[] | select(.visible and .focused) | .output'`
if [[ $CURRENTDESKOUTPUT = DVI-I-1 ]] || [[ $CURRENTDESKOUTPUT = LVDS* ]];
  then OUTPUTID="1";
elif [[ $CURRENTDESKOUTPUT = DVI-I-0 ]] || [[ $CURRENTDESKOUTPUT = VGA* ]] || [[ $CURRENTDESKOUTPUT = HDMI* ]];
  then OUTPUTID="2";
fi
NEWARGS="${ARGS//\$o/$OUTPUTID}"
echo $ARGS
echo $CURRENTDESKOUTPUT
echo $OUTPUTID
echo $NEWARGS
$wms $NEWARGS &> /dev/null
