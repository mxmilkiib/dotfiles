pactl set-sink-mute 0 false
pactl set-sink-volume 0 +3%
twmnc -c "raised to `amixer -c 0 get Master | grep -oe '[[:digit:]]*%'`" -t 'Volume' --sc "" --id 99
