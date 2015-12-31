#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

dnscrypt-proxy &

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Set Xorg keyboard layout
setxkbmap gb

# Source .Xresources for this session
xrdb -merge ~/.Xresources

# Make additional fonts available
xset +fp /usr/share/fonts/local
xset fp rehash

# xrandr --output DVI-I-1 --mode 1280x1024 --pos 0x0 --output VGA-1 --mode 1024x768 --pos 1280x195

# Set X background color to black
hsetroot -solid "#000000"

# Set background image
# sh ~/scripts/fehbg &
#~/scripts/gifbg.sh  ~/images/backgrounds/animated/bladerunner.gif &
# ~/scripts/nasa-apod-desktop/nasa_apod_desktop.py &
# python2 ~/scripts/nasa-apod-desktop/nasa_apod_desktop.py &
# feh --bg-max --no-xinerama /home/milk/documents/images/backgrounds/technical/git-vim-1280_and_1024.png
# feh --bg-fill --no-xinerama /home/milk/documents/images/backgrounds/6785760453_975351e590_o.jpg -Z       
feh --bg-fill --no-xinerama /home/milk/documents/images/backgrounds/highres/VnXDN9J.jpg -Z


# Give time for background to take
#sleep 4

# Give opacity to specific windows. See ~/.devilspie/opacity.ds
#devilspie -a &

# Redshift - changed screen colour temp
redshift-gtk -l 55.978301:-3.228586 -t 6000:4500 &

# Unclutter - hides the mouse cursor after 5 seconds of idle
unclutter -root -jitter 10 &

# As xmonad default to x cursor
xsetroot -cursor_name left_ptr &

# Start urxvt demon
urxvtd -q -f -o &

# Start xscreensaver
xscreensaver -nosplash &

# Disable screensaver on media fullscreen
lightsOn.sh 545 &

# Automount USB
udiskie &

# bmpanel2 --theme=Kupo_Finale-dark &
# tint2 &
# lxpanel &
# gnome-panel &
# consort-panel &
xfce4-panel --disable-wm-check --sm-client-disable &

# Volume system tray
# pa-applet &
volti &

# Radio streams
radiotray &

# Start GUI (F1 to cycle through)

# Composition manager
# compiz doesn't witk with openbox
# cairo-compmgr doesn't allow animated backgrounds
#xcompmgr &

# slow virtual desktop switching
# compton --respect-prop-shadow -bc -t -8 -l -9 -r 6 -o 0.7 &
# compton -cCGfF -o 0.38 -O 200 -I 200 -t 0.02 -l 0.02 -r 3.2 -D2 -m 0.88 -i 0 &
# compton -cCGfzb -o 0.8 -O 200 -I 200 -t -9 -l -9 -r 6 -D 2 -m 0.98 -e 1 -i 1 --respect-prop-shadow  --shadow-ignore-shaped

# Notification daemon
dunst &

# Dropbox w/ systray icon
dropboxes=(documents/dropbox-personal documents/beltane/Dropbox documents/dropbox-drumming)

# TMPHOME=~
# for dropbox in ${dropboxes[@]}; do
#    if ! [ -d $HOME/$dropbox ];then
#        mkdir $HOME/$dropbox
#    fi
#    HOME=$HOME/$dropbox/ /opt/dropbox/dropbox start -i &
# done
# HOME=TMPHOME

# oneko -fg "#555" -bg "#000" &

# skippy-xd --start-daemon &

# Start Jack for audio

# jack_control start &

# rulc -l > /dev/null || ruld &

# export LD_PRELOAD=libetc.so
# export LIBETC_BLACKLIST=/bin/cp:/bin/ln:/bin/ls:/bin/mv:/bin/rm:/usr/bin/find

autocutsel -fork &
# autocutsel -selection PRIMARY -fork &

# Update dynamic dns
inadyn -u milkmiruku -p DcBaCCcchangeiP -a milkmiruku.no-ip.info --dyndns_system default@no-ip.com --background &

export DEFAULT_SESSION=bspwm
export BSPWM_SOCKET=/tmp/bspwm-socket
export BSPWM_TREE=/tmp/bspwm.tree
export BSPWM_HISTORY=/tmp/bspwm.history
export BSPWM_STACK=/tmp/bspwm.stack
export PANEL_FIFO=/tmp/panel-fifo
export PANEL_HEIGHT=14

# exec gnome-session
# exec consort-session
# exec openbox

# Hotkeys
sxhkd &

case $1 in
  awesome)
    exec awesome
    ;;
  i3)
    exec i3
    ;;
  gnome)
    exec gnome-session
    ;;
  kde)
    exec startkde
    ;;
  bspwm|*)
    [ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
    # mkfifo "$PANEL_FIFO"
exec bspwm
    # exec bspwm -s "$PANEL_FIFO" -p W
    ;;
esac
