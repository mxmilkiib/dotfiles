#!/bin/sh

if [ $# -lt 1 ]; then 
    echo "First argument is destination. Second argument is 'new' or 'rerun'." >&2
    exit 1
elif [ $# -gt 2 ]; then
		echo "First argument is destination. Second argument is 'new' or 'rerun'." >&2
    exit 1
fi

if [ $2 = "new" ]; then
    SPARSEINPLACE="--sparse"
elif [ $2 = "rerun" ]; then
		SPARSEINPLACE="--inplace"
fi

START=$(date +%s)
rsync -aAX --no-whole-file --partial --stats $SPARSEINPLACE --ignore-errors /media/MILKY\'S\ HDD2/ $1 2> $1/rsync-error-log
FINISH=$(date +%s)
echo "-- Total backup time: $(( ($FINISH-$START) / 60 ))m, $(( ($FINISH-$START) % 60 ))s"

touch $1/backup-from-$(date '+%a_%d_%m_%Y_%H%M%S')
