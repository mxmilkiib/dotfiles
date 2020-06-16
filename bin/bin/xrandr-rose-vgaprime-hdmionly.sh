#!/bin/sh
killall polybar
bspc monitor HDMI1 --remove
xrandr --output LVDS1 --off --output DP1 --off -
feh --bg-fill --no-xinerama `return-wallpaper.sh`
nohup polybar standing-tray &! >/dev/null 2>&1
