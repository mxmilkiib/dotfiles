#!/bin/sh
EXTENTS=352
SRC_MOVE=28587
DEST_MOVE=28939
STOP_SRC=6139
DRIVE=/dev/sda1
while [ ${SRC_MOVE} -ge ${STOP_SRC} ]
do
	echo pvmove --alloc anywhere ${DRIVE}:${SRC_MOVE}+${EXTENTS} ${DRIVE}:${DEST_MOVE}+${EXTENTS}
	pvmove --alloc anywhere ${DRIVE}:${SRC_MOVE}+${EXTENTS} ${DRIVE}:${DEST_MOVE}+${EXTENTS}
	SRC_MOVE=`expr ${SRC_MOVE} - ${EXTENTS}`
	DEST_MOVE=`expr ${DEST_MOVE} - ${EXTENTS}`
done

