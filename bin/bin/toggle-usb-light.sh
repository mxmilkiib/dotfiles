#!/bin/env bash
PORT=$@
if [ "$(uhubctl -l 1-1.3 -p 4 | grep -cF ' off')" -eq 1 ]; then
    # port is off, enable
	uhubctl -l 1-1.3 -p 4 -a 1
else
    # port is on (or hub not connected), disable
	uhubctl -l 1-1.3 -p 4 -a 0
fi
