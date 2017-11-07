#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Redshift - changed screen colour temp
redshift-gtk -l 55.978301:-3.228586 -t 6000:4500 &

# Set Xorg keyboard layout
setxkbmap gb

xsettingsd &

# Source .Xresources for this session
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Make additional fonts available
xset +fp /usr/share/fonts/local
xset fp rehash

# xrandr --output DVI-I-1 --mode 1280x1024 --pos 0x0 --output VGA-1 --mode 1024x768 --pos 1280x195

# https://wiki.archlinux.org/index.php/Libetc
# export LD_PRELOAD=libetc.so
# export LIBETC_BLACKLIST=/bin/cp:/bin/ln:/bin/ls:/bin/mv:/bin/rm:/usr/bin/find

# Set X background color to black
# hsetroot -solid "#000000"

# Set background image
feh --bg-fill --no-xinerama ~/.wallpapers/VnXDN9J_colourised.png -Z

# Unclutter - hides the mouse cursor after 5 seconds of idle
unclutter --timeout 15 &

# As xmonad default to x cursor
xsetroot -cursor_name left_ptr &

# Start urxvt demon, quiet, connect to $DISPLAY, fork after control socket binding
# urxvtd -q -o -f &

# Start xscreensaver
xscreensaver -nosplash &

# Disable screensaver on media fullscreen
# lightsOn 545 &
#doesn't work??
caffeine &

# Automount USB script with smart system tray icon
# udiskie -s &
# mounts with unique path??

# Composition manager
# compton -b

# Notification daemon. ctrl-space to close, ctrl-shift-space to close all.
# dunst &
twmnd &

# Break timer
workrave &

# Volume system tray
# pa-applet &
# volti &
pnmixer &

# Radio streams
radiotray-ng &

# Battery monitor
# vattery &

# Update dynamic dns
dyndns &

# copy middle-mouse PRIMARY selection to ctrl-xcv/shift-insert CLIPBOARD. mostly useful when without a mouse.
# autocutsel -fork &
# copy ctrl-xcv / shift-insert CLIPBOARD to middle mouse PRIMARY selection buffer
# autocutsel -selection PRIMARY -fork &

# infrared control
flirc_util loadconfig ~/.config/flirc/my_flirc_config

# Start Jack for audio
# jack_control start &
# cadence-session-start --start &    # doesn't start jack sometimes

# Jack GUI 
# cadence --minimized &

# Set Pulseaudio to send audio to Jack by default

# Hotkeys
# sxhkd &

# Panel bar w/ pager, systray, program windows, weather, time, etc.
# xfce4-panel &

# Cat
# oneko -fg "#555" -bg "#000" -time 200000 -position +200+200 &


# Folder sync tray GUI (using web interface instead)
# syncthing-gtk &

# Octopi pacman update and package manager GUI
# pamac-tray &

# Make sure pulseaudio out is set to jack
# (sleep 30 && pacmd set-default-source jack_in && pacmd set-default-sink jack_out ) &

# Authentication agent
# pkttyagent &
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# lxpolkit &
/usr/lib/xfce-polkit/xfce-polkit &

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_PLATFORMTHEME=qt5ct
export QT_PLATFORM_PLUGIN=qt5ct


# Window manager

exec i3 >> ~/.i3/.i3log 2>&1

# exec selectwm
# exec xterm
# exec urxvt 

# export BSPWM_STATE=/tmp/bspwm-state.json
# exec bspwm
# exec adwm
# exec startxfce4
# exec herbstluftwm
# exec adwm
# exec howm
# exec fvwm2
# exec openbox

# loop method to allow restarting bspwm
# exec wm
