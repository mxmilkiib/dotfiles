#!/usr/bin/env bash
/usr/share/polybar/scripts/player-mpris-tail.py -f '{icon} {:artist:t18:{artist}:}{:artist: - :}{:t20:{title}:} %{A1:/usr/share/polybar/scripts/player-mpris-tail.py previous:} ⏮ %{A} %{A1:/usr/share/polybar/scripts/player-mpris-tail.py play-pause:} {icon-reversed} %{A} %{A1:/usr/share/polybar/scripts/player-mpris-tail.py next:} ⏭ %{A}' 2>/dev/null
