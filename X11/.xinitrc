# ~/.xinitrc
# Executed by startx (run your window manager from here)


# ███████╗███████╗███████╗███████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝██╔════╝██╔════╝██╔════╝██║██╔═══██╗████╗  ██║
# ███████╗█████╗  ███████╗███████╗██║██║   ██║██╔██╗ ██║
# ╚════██║██╔══╝  ╚════██║╚════██║██║██║   ██║██║╚██╗██║
# ███████║███████╗███████║███████║██║╚██████╔╝██║ ╚████║
# ╚══════╝╚══════╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
#                                                        
# ███████╗████████╗ █████╗ ██████╗ ████████╗    
# ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝    
# ███████╗   ██║   ███████║██████╔╝   ██║       
# ╚════██║   ██║   ██╔══██║██╔══██╗   ██║       
# ███████║   ██║   ██║  ██║██║  ██║   ██║       
# ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       
#                                               
# ███╗   ██╗██╗   ██╗██╗██████╗ ██╗ █████╗ 
# ████╗  ██║██║   ██║██║██╔══██╗██║██╔══██╗
# ██╔██╗ ██║██║   ██║██║██║  ██║██║███████║
# ██║╚██╗██║╚██╗ ██╔╝██║██║  ██║██║██╔══██║
# ██║ ╚████║ ╚████╔╝ ██║██████╔╝██║██║  ██║
# ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═╝
#                                           
# ██████╗ ██████╗ ██╗███╗   ███╗███████╗
# ██╔══██╗██╔══██╗██║████╗ ████║██╔════╝
# ██████╔╝██████╔╝██║██╔████╔██║█████╗  
# ██╔═══╝ ██╔══██╗██║██║╚██╔╝██║██╔══╝  
# ██║     ██║  ██║██║██║ ╚═╝ ██║███████╗
# ╚═╝     ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝
#                                        
# Needed for Nvidia working properly without a display manager
prime-offload

nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }" &
# export __NV_PRIME_RENDER_OFFLOAD=0

# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto

# xrandr --dpi 96


# sleep 2 && ~/.screenlayout/111-laptop-and-screen-above-primary.sh
# sleep 1 && ~/.screenlayout/04-laptop-only.sh
# sleep 1 && ~/.screenlayout/112-laptop-and-screen-above-and-below-as-clones.sh
# sleep 1 && ~/.screenlayout/hybrid/\ 21\ above\ +\ laptop
# sleep 1 && ~/.screenlayout/hybrid/\ 23\ laptop\ +\ tvclone
# sleep 1 && ~/.screenlayout/02-laptopbelow-screenabove.sh
# sleep 1 && ~/.screenlayout/__nvidia_laptop-screenabove.sh
# sleep 3 && ~/.screenlayout/___lx-3screen.sh
# sleep 3 && ~/.screenlayout/__4s.sh
# sleep 8 && ~/.screenlayout/___4-.sh
sleep 8 && ~/.screenlayout/_3-.sh
# sleep 8 && ~/.screenlayout/_3.sh



# ██╗  ██╗██████╗ ███████╗███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗
# ╚██╗██╔╝██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝
#  ╚███╔╝ ██████╔╝█████╗  ███████╗██║   ██║██║   ██║██████╔╝██║     █████╗  
#  ██╔██╗ ██╔══██╗██╔══╝  ╚════██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝  
# ██╔╝ ██╗██║  ██║███████╗███████║╚██████╔╝╚██████╔╝██║  ██║╚██████╗███████╗
# ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝
#                                                                            
# ███████╗     █████╗ ███╗   ██╗██████╗     ██╗  ██╗██╗███╗   ██╗██╗████████╗
# ██╔════╝    ██╔══██╗████╗  ██║██╔══██╗    ╚██╗██╔╝██║████╗  ██║██║╚══██╔══╝
# ███████╗    ███████║██╔██╗ ██║██║  ██║     ╚███╔╝ ██║██╔██╗ ██║██║   ██║   
# ╚════██║    ██╔══██║██║╚██╗██║██║  ██║     ██╔██╗ ██║██║╚██╗██║██║   ██║   
# ███████║    ██║  ██║██║ ╚████║██████╔╝    ██╔╝ ██╗██║██║ ╚████║██║   ██║   
# ╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   
#                                                                            
# ██╗  ██╗ ██████╗  ██████╗ ██╗  ██╗███████╗
# ██║  ██║██╔═══██╗██╔═══██╗██║ ██╔╝██╔════╝
# ███████║██║   ██║██║   ██║█████╔╝ ███████╗
# ██╔══██║██║   ██║██║   ██║██╔═██╗ ╚════██║
# ██║  ██║╚██████╔╝╚██████╔╝██║  ██╗███████║
# ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝
#                                           
# Source .Xresources for this session
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources


# Autostart X apps
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi



#  /$$$$$$ /$$   /$$ /$$$$$$$  /$$   /$$ /$$$$$$$$
# |_  $$_/| $$$ | $$| $$__  $$| $$  | $$|__  $$__/
#   | $$  | $$$$| $$| $$  \ $$| $$  | $$   | $$   
#   | $$  | $$ $$ $$| $$$$$$$/| $$  | $$   | $$   
#   | $$  | $$  $$$$| $$____/ | $$  | $$   | $$   
#   | $$  | $$\  $$$| $$      | $$  | $$   | $$   
#  /$$$$$$| $$ \  $$| $$      |  $$$$$$/   | $$   
# |______/|__/  \__/|__/       \______/    |__/   
#                                                  
#                                                  
#                                                  
#   /$$$$$$  /$$   /$$ /$$$$$$$        /$$   /$$ /$$$$$$
#  /$$__  $$| $$$ | $$| $$__  $$      | $$  | $$|_  $$_/
# | $$  \ $$| $$$$| $$| $$  \ $$      | $$  | $$  | $$  
# | $$$$$$$$| $$ $$ $$| $$  | $$      | $$  | $$  | $$  
# | $$__  $$| $$  $$$$| $$  | $$      | $$  | $$  | $$  
# | $$  | $$| $$\  $$$| $$  | $$      | $$  | $$  | $$  
# | $$  | $$| $$ \  $$| $$$$$$$/      |  $$$$$$/ /$$$$$$
# |__/  |__/|__/  \__/|_______/        \______/ |______/
#                                                        
#                                                        
#                                                        
# auth
# pkttyagent &
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# lxpolkit &
/usr/lib/xfce-polkit/xfce-polkit &


# input
numlockx &

# Keyboard brightness to '1' ('2' is max)
# brightnessctl --device='tpacpi::kbd_backlight' set 1

# Set Xorg keyboard layout
setxkbmap gb


# Make additional fonts available
xset +fp /usr/share/fonts/local
xset fp rehash

# xsettings daemon - informs apps what themes to use
xsettingsd &

# Set the mouse pointer graphic
xsetroot -cursor_name left_ptr &


# xinput disable "Synaptics TM3149-002"


#doing this in .profile
# export QT_QPA_PLATFORMTHEME=gtk2
# export QT_PLATFORMTHEME=gtk2
# export QT_PLATFORM_PLUGIN=qt5ct


# Start xscreensaver - disabled to save power
# xscreensaver -nosplash &

# ███████╗ ██████╗██████╗ ███████╗███████╗███╗   ██╗
# ██╔════╝██╔════╝██╔══██╗██╔════╝██╔════╝████╗  ██║
# ███████╗██║     ██████╔╝█████╗  █████╗  ██╔██╗ ██║
# ╚════██║██║     ██╔══██╗██╔══╝  ██╔══╝  ██║╚██╗██║
# ███████║╚██████╗██║  ██║███████╗███████╗██║ ╚████║
# ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝
#                                                    
# ██████╗  ██████╗ ██╗    ██╗███████╗██████╗      █████╗ ███╗   ██╗██████╗ 
# ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗    ██╔══██╗████╗  ██║██╔══██╗
# ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝    ███████║██╔██╗ ██║██║  ██║
# ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗    ██╔══██║██║╚██╗██║██║  ██║
# ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║    ██║  ██║██║ ╚████║██████╔╝
# ╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
#                                                                            
# ██████╗ ██╗      █████╗ ███╗   ██╗██╗  ██╗██╗███╗   ██╗ ██████╗ 
# ██╔══██╗██║     ██╔══██╗████╗  ██║██║ ██╔╝██║████╗  ██║██╔════╝ 
# ██████╔╝██║     ███████║██╔██╗ ██║█████╔╝ ██║██╔██╗ ██║██║  ███╗
# ██╔══██╗██║     ██╔══██║██║╚██╗██║██╔═██╗ ██║██║╚██╗██║██║   ██║
# ██████╔╝███████╗██║  ██║██║ ╚████║██║  ██╗██║██║ ╚████║╚██████╔╝
# ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
#                                                                   
# power
# disable screensaver and DPMS so screens never blank
xset s off
xset -dpms
xset s noblank


# Disable screensaver on media fullscreen
# lightsOn 545 &
#doesn't work??
# /usr/lib/xscreensaver/xscreensaver-systemd &
caffeine &
# caffeine-ng &


# Suspend, hibernate, etc.
# lxqt-powermanagement &


# https://wiki.archlinux.org/index.php/Libetc
# export LD_PRELOAD=libetc.so
# export LIBETC_BLACKLIST=/bin/cp:/bin/ln:/bin/ls:/bin/mv:/bin/rm:/usr/bin/find

# Set X background color to black
# hsetroot -solid "#000000"

# Set background image
# feh --bg-fill --no-xinerama ~/.wallpapers/VnXDN9J_colourised.png
# feh --bg-fill --no-xinerama `return-wallpaper.sh`

# Flash windows on focus
# flashfocus &

# Unclutter - hides the mouse cursor after 15 seconds of idle
unclutter --timeout 15 &

# Start urxvt demon, quiet, connect to $DISPLAY, fork after control socket binding
# urxvtd -q -o -f &

# Composition manager
# compton &
# compton -b										# see ~/.config/compton.conf
# compton --respect-prop-shadow -bc -t -8 -l -9 -r 6 -o 0.7 &
# compton -cCGfF -o 0.38 -O 200 -I 200 -t 0.02 -l 0.02 -r 3.2 -D2 -m 0.88 -i 0 &
# compton -cCGfzb -o 0.8 -O 200 -I 200 -t -9 -l -9 -r 6 -D 2 -m 0.98 -e 1 -i 1 --respect-prop-shadow  --shadow-ignore-shape
#  ██████╗ ██████╗ ███╗   ███╗██████╗  ██████╗ ███████╗██╗████████╗ ██████╗ 
# ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██╔═══██╗██╔════╝██║╚══██╔══╝██╔═══██╗
# ██║     ██║   ██║██╔████╔██║██████╔╝██║   ██║███████╗██║   ██║   ██║   ██║
# ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║   ██║╚════██║██║   ██║   ██║   ██║
# ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ╚██████╔╝███████║██║   ██║   ╚██████╔╝
#  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═╝    ╚═════╝ 
#                                                                            
# ██████╗ 
# ██╔══██╗
# ██████╔╝
# ██╔══██╗
# ██║  ██║
# ╚═╝  ╚═╝
#         
picom -b -o 0 -i 1 -D 3 -m 0.98 --backend xrender
# picom --backend xrender &


# screen brightness based on ambient brightness
# clight --lat 55.96 --lon 3.19 &


# Notification daemon. ctrl-space to close, ctrl-shift-space to close all.
# dunst &

# script to alter the mouse pointer speed
# pointerspeed.sh 0.5

# infrared control
# flirc_util loadconfig ~/.config/flirc/my_flirc_config


#  █████╗ ██╗   ██╗██████╗ ██╗ ██████╗      █████╗ ███╗   ██╗██████╗ 
# ██╔══██╗██║   ██║██╔══██╗██║██╔═══██╗    ██╔══██╗████╗  ██║██╔══██╗
# ███████║██║   ██║██║  ██║██║██║   ██║    ███████║██╔██╗ ██║██║  ██║
# ██╔══██║██║   ██║██║  ██║██║██║   ██║    ██╔══██║██║╚██╗██║██║  ██║
# ██║  ██║╚██████╔╝██████╔╝██║╚██████╔╝    ██║  ██║██║ ╚████║██████╔╝
# ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
#                                                                     
# ███╗   ███╗███████╗██████╗ ██╗ █████╗ 
# ████╗ ████║██╔════╝██╔══██╗██║██╔══██╗
# ██╔████╔██║█████╗  ██║  ██║██║███████║
# ██║╚██╔╝██║██╔══╝  ██║  ██║██║██╔══██║
# ██║ ╚═╝ ██║███████╗██████╔╝██║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝
#                                        
### audio things!

# Start Jack for audio
# jack_control start &
# cadence-session-start --start &    # doesn't start jack sometimes
# cadence-session-start --system-start

# JACK GUI
# cadence --minimized &

# Audio session manager
#raysession --start-session basic &

# snapcast reciever
# snapauto.sh &

# mpris from mpd server
# mpd-mpris -host 192.168.1.3 &
mpDris2 &

# make playerctl always target most recently active player
playerctld &

mpdproxy &


# Panel bar w/ pager, systray, program windows, weather, time, etc.
# xfce4-panel --disable-wm-check &
# perlpanel &
# xde-panel &
# polybar sitting &


# ████████╗██████╗  █████╗ ██╗   ██╗    ███████╗██╗   ██╗███╗   ██╗ ██████╗
# ╚══██╔══╝██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔════╝╚██╗ ██╔╝████╗  ██║██╔════╝
#    ██║   ██████╔╝███████║ ╚████╔╝     ███████╗ ╚████╔╝ ██╔██╗ ██║██║     
#    ██║   ██╔══██╗██╔══██║  ╚██╔╝      ╚════██║  ╚██╔╝  ██║╚██╗██║██║     
#    ██║   ██║  ██║██║  ██║   ██║▄█╗    ███████║   ██║   ██║ ╚████║╚██████╗
#    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝╚═╝    ╚══════╝   ╚═╝   ╚═╝  ╚═══╝ ╚═════╝
#                                                                            
#  █████╗ ███╗   ██╗██████╗ 
# ██╔══██╗████╗  ██║██╔══██╗
# ███████║██╔██╗ ██║██║  ██║
# ██╔══██║██║╚██╗██║██║  ██║
# ██║  ██║██║ ╚████║██████╔╝
# ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
#                            
# ██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗███████╗███████╗
# ██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝██║██╔════╝██╔════╝
# ██║   ██║   ██║   ██║██║     ██║   ██║   ██║█████╗  ███████╗
# ██║   ██║   ██║   ██║██║     ██║   ██║   ██║██╔══╝  ╚════██║
# ╚██████╔╝   ██║   ██║███████╗██║   ██║   ██║███████╗███████║
#  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝   ╚═╝╚══════╝╚══════╝
#                                                              
### Notification icon area / systray

# Automount devices, with smart system tray icon
# udiskie -san &
udiskie -tan &


# clipboard
# copy middle-mouse PRIMARY selection to ctrl-xcv/shift-insert CLIPBOARD. mostly useful when without a mouse.
# autocutsel -fork &
# copy ctrl-xcv / shift-insert CLIPBOARD to middle mouse PRIMARY selection buffer
# autocutsel -selection PRIMARY -fork &


# Break timer
# workrave &

# Radio streams
# radiotray-ng &
# goodvibes --status-icon &
# shortwave &

# Block Spotify ads
spotblock-rs &

# netctl status
# netmon &
#netctl-gui &

# Update dynamic dns
# dyndns &


# Battery monitor
# [[ $HOST = "rose*" || "red*" ]] && cbatticon &
# [[ $HOST = "rose*" || "red*" ]] && tp-battery-icon &


# Folder sync tray GUI (using web interface instead), minimized
# syncthing-gtk --minimized --header &
syncthing-gtk --header &

nextcloud &

# signal-desktop --start-in-tray &

keepassxc ~/sync/keepassxc-mb.kdbx &

# Octopi pacman update and package manager GUI
# pamac-tray &

# Hotkeys
# sxhkd &


deskflow &


# Make sure pulseaudio out is set to jack
# (sleep 30 && pacmd set-default-source jack_in && pacmd set-default-sink jack_out ) &

# Use mouse button8 as left windows key
# xinput set-button-map 1 2 3 4 5 6 7 12 9 10 11 12
# button8-to-lwin.py &

# Cat
#oneko -fg "#555" -bg "#000" -time 200000 -position +200+200 &
# neko-go -speed 1 & 


# # fix wonkey internal laptop keyboard
# FLOATKB=`xinput | grep Translated | awk -F ' ' '{print substr($7,length($7)-1,length($7))}'` && xinput float $FLOATKB

#
# # eval `luarocks path --bin`
#


# Change screen colour temp/brightness
# redshift-gtk -l 55.978301:-3.228586 -t 6000:4500 &
# sleep 3 && screendimmer &
sleep 2 && ~/bin/start-gammy-auto-close-dialog.sh &

# Logitech settings, start hidden to tray
sleep 5 && solaar -w hide &


# bt
sleep 10 && blueman-applet &


# screenshot systray helper
# sleep 8 && flameshot &

# sleep 6 && agordejo --session-root ~/media/audio/projects/NSM --load-session 0_base --hide &

# connect to mobile kdeconnect app
sleep 25 && kdeconnect-indicator &

# Script that changes a window border colour on urgent signal
#bspwm-urgent-border.sh &


# Volume system tray
# pa-applet &
#volti &
# pnmixer &
# pasystray --no-icon-tooltip --no-notify --volume-max=100 &
kmix --keepvisibility &
# sleep 16 && kmix --keepvisibility &
#volumeicon &


sleep 7 && indicator-sound-switcher &


# Emoji picker app - ctrl-alt-ez
# emote &


# Mouse tweaks, G502
# turn accelleration off
# xinput set-prop "pointer:Logitech G502 HERO Gaming Mouse" 335 0, 0, 0
# change vertical and horizontal speed matrix, lower sensitivity
# xinput set-prop "pointer:Logitech G502 HERO Gaming Mouse" 190 1.5000, 0.000000, 0.000000, 0.000000, 1.500, 0.000000, 0.000000, 0.000000, 1.000000
# xinput set-prop "pointer:Logitech G502 HERO Gaming Mouse" 190 2.0000, 0.000000, 0.000000, 0.000000, 2.00, 0.000000, 0.000000, 0.000000, 1.000000


# Apple Magic Trackpad tweaks
# scoll at right edge
# xinput set-prop "pointer:Apple Inc. Magic Trackpad" 332 0, 1, 0
xset s off
# "natural" scroll off
# xinput set-prop "$(xinput list | grep 'Magic Trackpad' | tail -n 1 | cut -f2 | grep -o '[0-9]*')" 318 0
# turn accelleration off
xinput set-prop "$(xinput list | grep 'Magic Trackpad' | tail -n 1 | cut -f2 | grep -o '[0-9]*')" 342 0, 0, 0
# change vertical and horizontal speed matrix, lower sensitivity
# xinput set-prop "pointer:Apple Inc. Magic Trackpad" 190 4.8000000, 0.000000, 0.000000, 0.000000, 3.000000, 0.000000, 0.000000, 0.000000, 1.000000
xinput set-prop "$(xinput list | grep 'Magic Trackpad' | tail -n 1 | cut -f2 | grep -o '[0-9]*')" 190 4.8000000, 0.000000, 0.000000, 0.000000, 3.000000, 0.000000, 0.000000, 0.000000, 1.000000



# Select arandr scripts from the tray
arandr-indicator &


(sleep 20 && copyq &)


# ssh-agent
#broken in bspwm
# ssh agent handled by KeePassXC; do not start a standalone agent here
# eval "$(ssh-agent)"


# dockd --daemon &

# optimus-manager-qt &


# Apply ICC profile to laptop screen
# Thinkpad P50 colour profile fix
# https://www.notebookcheck.net/Lenovo-ThinkPad-P50-Workstation-Review.158713.0.html
# ████████╗██╗  ██╗███████╗███╗   ███╗███████╗   
# ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝   
#    ██║   ███████║█████╗  ██╔████╔██║█████╗     
#    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝     
#    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗▄█╗
#    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝
#                                                
#  ██████╗ ██████╗ ██╗      ██████╗ ██████╗      █████╗ ███╗   ██╗██████╗ 
# ██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗    ██╔══██╗████╗  ██║██╔══██╗
# ██║     ██║   ██║██║     ██║   ██║██████╔╝    ███████║██╔██╗ ██║██║  ██║
# ██║     ██║   ██║██║     ██║   ██║██╔══██╗    ██╔══██║██║╚██╗██║██║  ██║
# ╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║    ██║  ██║██║ ╚████║██████╔╝
#  ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
#                                                                          
# ██╗ ██████╗ ██████╗
# ██║██╔════╝██╔════╝
# ██║██║     ██║     
# ██║██║     ██║     
# ██║╚██████╗╚██████╗
# ╚═╝ ╚═════╝ ╚═════╝
#                     
xcalib -s 0 ~/.local/share/icc/thinkpad_p50_icc_LP156WF6_SPK1.icm


#~/.screenlayout/_hybrid_2-laptop-screenabove.sh
#~/.screenlayout/__nvidia_laptop-screenabove.sh


# ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗
# ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║
# ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║
# ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║
# ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝
#  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ 
#                                                    
# ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗ 
# ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗
# ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝
# ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗
# ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║
# ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
#                                                                
### Window manager

# exec startlxde
# exec cinnamon-session

#exec i3
# exec enlightenment_start
# exec audacity
# exec tdm --xstart
# exec i3 >> /var/tmp/log/i3log 2>&1

# exec adwm -f ~/.config/adwm/adwmrc
# exec adwm
# exec xde-session choose

# exec selectwm
# exec xterm
#exec urxvt


# xlayoutdisplay &
# autorandr &
# autorandr --skip-options crtc mix &

# exec prime-run awesome --no-argb
exec prime-run awesome

# exec prime-run Hyprland 

# exec prime-run lxqt-session

#exec bspwm
# exec ssh-agent bspwm
# exec bspwm -c /home/milk/sync/dotfiles/bspwm/.config/bspwm/bspwmrc
# exec bspwm -c /home/milk/.config/bspwm/bspwmrc
#exec startxfce4
# exec herbstluftwm
# exec howm
# exec fvwm2
# exec openbox
