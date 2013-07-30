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

# Source .Xresources for this session
xrdb -merge ~/.Xresources

xrandr --output DVI-I-1 --mode 1280x1024 --pos 0x0 --output VGA-1 --mode 1024x768 --pos 1280x195

# Start the urxvtd daemon
# urxvtd -q -f -o &

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
gtk-redshift -l 55.978301:-3.228586 -t 6500:4500 &

# Unclutter - hides the mouse cursor after 5 seconds of idle
unclutter -root -jitter 10 &

# As xmonad default to x cursor
xsetroot -cursor_name left_ptr &

# Start urxvt demon
urxvtd -q -f -o &

# Start xscreensaver
xscreensaver -nosplash &

# Automount USB
udiskie &

# Volume systemtray
sxhkd &

# bmpanel2 --theme=Kupo_Finale-dark &
# tint2 &
# lxpanel &
# gnome-panel &
# consort-panel &
xfce4-panel &

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
compton -cCGfzb -o 0.8 -O 200 -I 200 -t -9 -l -9 -r 6 -D 2 -m 0.98 -e 1 -i 1 --respect-prop-shadow  --shadow-ignore-shaped

# Notification daemon
dunst &

# oneko -fg "#555" -bg "#000" &

# skippy-xd --start-daemon &

# export LD_PRELOAD=libetc.so
# export LIBETC_BLACKLIST=/bin/cp:/bin/ln:/bin/ls:/bin/mv:/bin/rm:/usr/bin/find

export DEFAULT_SESSION=bspwm
export BSPWM_SOCKET=/tmp/bspwm-socket
export PANEL_FIFO=/tmp/panel-fifo

# exec gnome-session
# exec consort-session
# exec openbox

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
    mkfifo "$PANEL_FIFO"
    exec bspwm -s "$PANEL_FIFO"
    ;;
esac
