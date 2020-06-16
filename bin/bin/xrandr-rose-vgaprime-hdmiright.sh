#!/bin/sh
$(sleep 2 && xrandr --output LVDS1 --off --output DP1 --off --output HDMI1 --mode 1920x1080 --pos 1920x0 --rotate normal --output VGA1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off)
killall polybar
feh --bg-fill --no-xinerama `return-wallpaper.sh`
MONITOR=VGA1 polybar sitting-tray &
bspc monitor --focus VGA1
bspc monitor VGA1 -d A1 A2 A3 A4 A5 A6 A7 A8 A9 A0 A- A=
bspc monitor HDMI1 -d B1 B2 B3 B4 B5 B6 B7 B8 B9 B0 B- B=
sleep 1
MONITOR=HDMI1 polybar standing &
