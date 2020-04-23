#!/bin/sh
# Uses xwinwrap to display given animated .gif in the center of the screen
# via http://forums.linuxmint.com/viewtopic.php?f=18&t=20508

if [ $# -ne 1 ]; then
    echo 1>&2 Usage: $0 image.gif
    exit 1
fi

#get screen resolution
SCRH=`xrandr | awk '/current/ { print $8 }'`
SCRW=`xrandr | awk '/current/ { print $10 }'`
SCRW=${SCRW%\,}

#get gif resolution
IMGHW=`gifsicle --info $1 | awk '/logical/ { print $3 }'`
IMGH=${IMGHW%x*}
IMGW=${IMGHW#*x}

#calculate position
POSH=$((($SCRH/2)-($IMGH/2)))
POSW=$((($SCRW/2)-($IMGW/2)))

xwinwrap -g ${IMGHW}+${POSH}+${POSW} -b -ov -ni -nf -s -st -sp  -- gifview -w WID $1 -a

exit 0
