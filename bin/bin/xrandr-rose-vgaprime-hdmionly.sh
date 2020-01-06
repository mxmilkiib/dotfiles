#!/bin/sh
killall polybar
xrandr --output LVDS1 --off --output DP1 --off --output VGA1 --off --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
bspc monitor HDMI1 --reset-desktops A1 A2 A3 A4 A5 A6 A7 A8 A9 A0 A- A=
feh --bg-fill --no-xinerama ~/.wallpapers/danielle_at_sea_flickr.jpg
nohup polybar standing-tray &! >/dev/null 2>&1
