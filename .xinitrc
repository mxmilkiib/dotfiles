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

# Start the urxvtd daemon
# urxvtd -q -f -o &

# Set X background color to black
hsetroot -solid "#000000"

# Composition manager
# compiz doesn't witk with openbox
# cairo-compmgr doesn't allow animated backgrounds
xcompmgr &

# Set background image
# sh ~/scripts/fehbg &
#~/scripts/gifbg.sh  ~/images/backgrounds/animated/bladerunner.gif &
~/scripts/nasa-apod-desktop/nasa_apod_desktop.py &

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

# Set new NASA background
python2 ~/scripts/nasa-apod-desktop/nasa_apod_desktop.py &

# Start urxvt demon
urxvtd -q -f -o &

# Start xscreensaver
xscreensaver -nosplash &

# Start Openbox
#exec openbox
exec awesome
