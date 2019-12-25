#!/bin/bash

node_number=$(bspc query --nodes --desktop --node .window | wc -l)

case $node_number in
	1) echo "split_dir=south";;
	2) bspc config split_ratio 0.45 && bspc node -f biggest.local && bspc node -f south && echo "split_dir=east";;
	# 3) echo "split_dir=south";;
	3) bspc config split_ratio 0.5 && bspc node -f biggest.local && echo "split_dir=east";;
	# 4) echo "bspc desktop -f next";;
	4) bspc config split_ratio 0.5 && bspc node -f biggest.local && echo "split_dir=south";;
	5) bspc config split_ratio 0.5 && bspc node -f biggest.local && echo "split_dir=south";;
	6) bspc config split_ratio 0.5 && bspc node -f biggest.local && bspc node -f south && echo "split_dir=south";;
	7) bspc config split_ratio 0.65 && bspc node -f biggest.local && echo "split_dir=south";;
esac
