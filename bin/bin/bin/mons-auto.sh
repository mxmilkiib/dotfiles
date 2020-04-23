#!/bin/bash
# logfile="/tmp/setup-display"
# if [[ -f "$logfile" ]]; then
	# cat $logfile | tail -n10 > $logfile.tmp
	# mv $logfile.tmp $logfile
# fi
# 
# exec >> $logfile
# exec 2>&1

sleep 3

mons_out=$(mons)
num_monitors=$(echo "$mons_out" | grep "Monitors" | awk '{print $2}')
mons_mode=$(echo "$mons_out" | grep "Mode" | awk '{print $2}')
edp=$(echo "$mons_out" | grep "LVDS" | awk '{print $2}')
hdmi=$(echo "$mons_out" | grep "VGA" | awk '{print $2}')

echo
date
echo "$mons_out"
if [[ $num_monitors -eq 2 ]]; then
	echo "Two displays."
	if [[ "$mons_mode" == "extend" ]]; then
		echo "Already extended."
		exit 0
	fi
	echo "External only.."
	mons -s
	while [[ "$ret" != '[{"success":true}]' ]]; do
		echo "Moving workspaces to output $hdmi..."
		ret=$(i3-msg "[class=\".*\"] move workspace to output $hdmi" | grep '"success"')
		sleep .25
	done
else
	echo "Internal only.."
	mons -o
fi
