#!/bin/bash

node_number=$(bspc query --nodes --desktop --node .window | wc -l)

case $node_number in
	1) echo "split_dir=east";;
	2) bspc node -f biggest.local && echo "split_dir=south";;
	# 3) echo "split_dir=south";;
	3) bspc node -f biggest.local && echo "split_dir=south";;
	# 4) echo "bspc desktop -f next";;
	4) bspc node -f biggest.local && bspc node -f south && echo "split_dir=south";;
	5) bspc node -f biggest.local && bspc node -f east && echo "split_dir=south";;
	6) bspc node -f biggest.local && bspc node -f east && bspc node -f south && echo "split_dir=south";;
	7) bspc node -f biggest.local && echo "split_dir=south";;
esac
