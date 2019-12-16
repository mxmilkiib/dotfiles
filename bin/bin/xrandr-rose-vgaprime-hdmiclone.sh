#!/bin/sh
xrandr --output LVDS1 --off --output DP1 --off --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal --output VGA1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
killall polybar
feh --bg-fill --no-xinerama ~/.wallpapers/danielle_at_sea_flickr.jpg
MONITOR=VGA1 polybar sitting &
