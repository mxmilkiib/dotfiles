#!/bin/sh
EXTENTS=126
SRC_MOVE=7115
DEST_MOVE=6989
STOP_SRC=28489
DRIVE=/dev/sda1

while [ ${SRC_MOVE} -lt `expr ${STOP_SRC} + ${EXTENTS}` ]
do
	echo pvmove --alloc anywhere ${DRIVE}:${SRC_MOVE}+${EXTENTS} ${DRIVE}:${DEST_MOVE}+${EXTENTS}
	pvmove --alloc anywhere ${DRIVE}:${SRC_MOVE}+${EXTENTS} ${DRIVE}:${DEST_MOVE}+${EXTENTS}
	SRC_MOVE=`expr ${SRC_MOVE} + ${EXTENTS}`
	DEST_MOVE=`expr ${DEST_MOVE} + ${EXTENTS}`
done

