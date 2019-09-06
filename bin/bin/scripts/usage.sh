#!/bin/bash

declare -A usage

exec 0< <(pacman -Ql | grep bin)

while read pkg binary; do
  lastused=$(stat -c '%X' "$binary")
  if [[ -z ${usage[$pkg]} ]] || (( lastused > ${usage[$pkg]} )); then
    usage[$pkg]=$lastused
  fi
done

for key in "${!usage[@]}"; do
  printf '%s\t%s\n' "${usage[$key]}" "$key"
done | sort -rn | while read time pkg; do
  printf '%(%c)T\t%s\n' "$time" "$pkg"
done
