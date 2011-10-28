# prompt.zsh: A custom prompt for zsh.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# PROMPT="%n@%m: %1~> "

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
RPS1="$FG[214](%D{%H:%M})$PR_NO_COLOR"

#PR_YELLOW
