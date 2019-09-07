#!/bin/sh

START=$(date +%s)
rsync -avh --inplace --no-whole-file --progress --stats --log-file=/tmp/rlog /* $1 --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/home/*/.gvfs,/var/lib/pacman/sync/*,/home/*/.thumbnails/*,/home/*/.mozilla/firefox/*.default/Cache/*,/home/*/.cache/chromium/*,/home/*/.opera/cache/*,/var/lib/mpd/music*,/var/tmp/*}
FINISH=$(date +%s)
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"

# touch $1/"Backup from $(date '+%A, %d %B %Y, %T')"
