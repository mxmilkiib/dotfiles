cat ~/.config/i3/config | grep -e '^bind\|\#\#' | sed 's/bindsym //g;s/--release //g;s/^button. nop//g' | GREP_COLORS='mt=01;32' grep -E --color=always '^.mod+[^ ]*|$' | GREP_COLORS='mt=01;31' grep -E --color=always '\#\#.*$|$' | sed 's/\#\#\#/\n/g;s/\#\#/\n\#\#/g;s/mod+\S*/&\n/g;s/^ / \ /g;s/\$mod/ mod/g;s/+/ + /g' | less -r