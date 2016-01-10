#!/bin/bash
readarray -t PROPS < <(xwinfo -ts $1)

TYPE=${PROPS[0]}
STATE=(${PROPS[1]})

RULE=()

case "$TYPE" in
    dock|desktop|notification)  RULE+=("manage=off")    ;;
    toolbar|utility)            RULE+=("focus=off")     ;;
    desktop)                    RULE+=("lower=on")      ;;
esac

for s in $STATE; do
    case $s in
        sticky)                 RULE+=("sticky=on")     ;;
        fullscreen)             RULE+=("fullscreen=on") ;;
    esac
done

echo "${RULE[*]}"
