# /etc/zsh/zprofile: system-wide .zprofile file for zsh(1).
#
# This file is sourced only for login shells (i.e. shells
# invoked with "-" as the first character of argv[0], and
# shells invoked with the -l flag.)
#
# Global Order: zshenv, zprofile, zshrc, zlogin

autoload -Uz promptinit
promptinit

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi

# Prompt
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done

PR_NO_COLOR="%{$terminfo[sgr0]%}"
PS1="%(#~$PR_RED~$PR_CYAN)%n$PR_WHITE@$PR_MAGENTA%m$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR %(!.#.$)$b % "
RPS1="$PR_YELLOW(%D{%H:%M})$PR_NO_COLOR"

