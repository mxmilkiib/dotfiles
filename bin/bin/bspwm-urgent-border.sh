#! /bin/bash

bspc subscribe node_flag | while read -a msg; do
    [ "${msg[4]}" = "urgent" ] && [ "${msg[5]}" = "on" ] && chwb -c 0xffffff "${msg[3]}"
done
