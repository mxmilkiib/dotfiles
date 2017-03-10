#!/bin/sh

if [ $# -lt 1 ]; then 
    echo "First argument is destination. Second argument is 'new' or 'rerun'." >&2
    exit 1
elif [ $# -gt 2 ]; then
		echo "First argument is destination. Second argument is 'new' or 'rerun'." >&2
    exit 1
fi

if [ $2 = "new" ]; then
    SPARCEINPLACE="--sparse"
elif [ $2 = "rerun" ]; then
		SPARCEINPLACE="--inplace"
fi

START=$(date +%s)
rsync -aAX --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found} \
--exclude={/home/*/.gvfs,/home/*/.thumbnails,/home/*/.cache,/home/*/.cache/mozilla/*,/home/*/.cache/chromium/*} \
--exclude={/home/*/.local/share/Trash/,/home/*/.macromedia,/var/lib/mpd/*,/var/lib/pacman/sync/*,/var/tmp/*} \
--no-whole-file --partial --stats $SPARCEINPLACE --ignore-errors / $1 2> rsync-error-log
FINISH=$(date +%s)
echo "-- Total backup time: $(( ($FINISH-$START) / 60 ))m, $(( ($FINISH-$START) % 60 ))s"

touch $1/backup-from-$(date '+%a_%d_%m_%Y_%H%M%S')

# if refining excluded, --delete-excluded
