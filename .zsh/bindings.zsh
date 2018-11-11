# two thirds through fixing

# use 'bindkey' to list current key bindings

# create human readable global associative array from local terminfo in variable $key
# this is instead of hardbinding to control codes as these can vary between terminals
# make sure your terminfo is corrext! set in .Xresources. bad idea to overwrite $TERM.
# to add other keys to this hash, see: man 5 terminfo

typeset -g -A key

# makes $terminfo array available
zmodload zsh/terminfo

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Backspace]=${terminfo[kbs]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

#  'BackTab'      "$terminfo[kcbt]"
# key[Backspace]='^?'
key[CtrlLeft]=${terminfo[kLFT5]}
key[CtrlRight]=${terminfo[kRFT5]}


# setup key accordingly
[[ -n {${key[Home]}}      ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"       ]]  && bindkey  "${key[End]}"     end-of-line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

[[ -n "${key[Insert]}"    ]]  && bindkey  "${key[Insert]}"  overwrite-mode #broken?
[[ -n "${key[Backspace]}" ]]  && bindkey  "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]]  && bindkey  "${key[Delete]}"  delete-char
# [[ -n "${key[Up]}"        ]]  && bindkey  "${key[Up]}"      up-line-or-history
# [[ -n "${key[Down]}"      ]]  && bindkey  "${key[Down]}"    down-line-or-history
# type then press up/down to search history
bindkey "${key[Up]}" history-substring-search-up
bindkey "${key[Down]}" history-substring-search-down
[[ -n "${key[Left]}"      ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"     ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n "${key[PageUp]}"    ]]  && bindkey  "${key[PageUp]}"  beginning-of-history
[[ -n "${key[PageDown]}"  ]]  && bindkey  "${key[PageDown]}" end-of-history


# [[ -n "${key[CtrlLeft]}" ]]  && bindkey  "${key[CtrlLeft]}" backward-word
# [[ -n "${key[CtrlRight]}" ]]  && bindkey  "${key[CtrlRight]}" forward-word

# ctrl-left, ctrl-right - move cursor over words
# xterm-256-color?
bindkey '^[[1;5D' emacs-backward-word
bindkey '^[[1;5C' emacs-forward-word
# urxvt
bindkey "\eOd" emacs-backward-word
bindkey "\eOc" emacs-forward-word # lands between words, not on first char

# alt-left, alt-right - move cursor to start of previous or next word
# same as ctrl-left/right, just fixes accidental pressing. to change to cursor location on end of jump..
# xterm
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
# urxvt
bindkey '^[^[[D'  backward-word
bindkey '^[^[[C'  forward-word

bindkey '^b' backward-word
bindkey '^f' forward-word

# ctrl-backspace - deletes word to left of cursor
# bindkey \" backward-kill-word
bindkey '^h' backward-kill-word

# ctrl-del - deletes word to right of cursor
# xterm
bindkey '^[[3;5~' kill-word
# urxvt
bindkey '^[[3^'   kill-word
bindkey '^d'      kill-word

# Type command then ctrl-up/ctrl-down to search history
# bindkey "^[[1;5A" history-beginning-search-backward
# bindkey "^[[1;5B" history-beginning-search-forward
# bindkey "\e[A" history-beginning-search-backward
# bindkey "\e[B" history-beginning-search-forward

# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# bindkey "^S" history-incremental-search-forward
# bindkey "^R" history-incremental-search-backward

bindkey "^p" up-line-or-search
bindkey "^n" down-line-or-search


key[F1]=${terminfo[kf1]}
key[F2]=${terminfo[kf2]}
key[F3]=${terminfo[kf3]}
key[F4]=${terminfo[kf4]}
key[F5]=${terminfo[kf5]}
key[F6]=${terminfo[kf6]}
key[F7]=${terminfo[kf7]}
key[F8]=${terminfo[kf8]}
key[F9]=${terminfo[kf9]}
key[F10]=${terminfo[kf10]}
key[F11]=${terminfo[kf11]}
key[F12]=${terminfo[kf12]}


for k in ${(k)key} ; do
    # $terminfo[] entries are weird in ncurses application mode...
    [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
done
unset k


# Open man page for command in editing buffer
bindkey $key[F1] run-help

# Insert "sudo " at the beginning of the line
function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
  fi
}
zle -N prepend-sudo
bindkey "$key[F2]" prepend-sudo


autoload edit-command-line
zle -N edit-command-line
bindkey $key[F4] edit-command-line



# Ctrl-w - push line to buffer stack, 
# bindkey '^w' push-line

# Ctrl-e - pop line from buffer stack
# bindkey '^e' get-line


# Ctrl-b - Comment out line with # and execute
# bindkey '^b' pound-insert

# bindkey "^V" quoted-insert

# Ctrl-k - delete after cursor
bindkey "^k" kill-line

# Ctrl-u - delete everything  
bindkey "^u" kill-whole-line


bindkey "\e[Z" reverse-menu-complete # Shift+Tab

# zsh - Ctrl-/ (also ctrl-shift-- i.e. ctrl-_) - add completion item to editing buffer but don't close completion menu
bindkey '^_' accept-and-hold

# Insert accented character
# https://github.com/johan/zsh/blob/master/Functions/Zle/insert-composed-char
# autoload insert-composed-char
# zle -N insert-composed-char
# bindkey "^K" insert-composed-char

# bindkey "^X" execute-named-cmd


bindkey " " magic-space # do history expansion ($ !ssh ...) on space

# bindkey "\e[2~" quoted-insert

# bindkey '^i' expand-or-complete-prefix

# bits from https://github.com/simongmzlj/dotfiles/blob/master/zsh/zshrc



insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo


# if [[ "$TERM" != emacs ]]; then
# [[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs "$terminfo[kdch1]" delete-char
# [[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
# [[ -z "$terminfo[kend]" ]] || bindkey -M emacs "$terminfo[kend]" end-of-line
# [[ -z "$terminfo[kich1]" ]] || bindkey -M emacs "$terminfo[kich1]" overwrite-mode
# [[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
# [[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
# [[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line
# [[ -z "$terminfo[kich1]" ]] || bindkey -M vicmd "$terminfo[kich1]" overwrite-mode
#
# [[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" vi-up-line-or-history
# [[ -z "$terminfo[cuf1]" ]] || bindkey -M viins "$terminfo[cuf1]" vi-forward-char
# [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
# [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
# [[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
# [[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char
#
# # ncurses fogyatekos
# [[ "$terminfo[kcuu1]" == "^[O"* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" vi-up-line-or-history
# [[ "$terminfo[kcud1]" == "^[O"* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" vi-down-line-or-history
# [[ "$terminfo[kcuf1]" == "^[O"* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
# [[ "$terminfo[kcub1]" == "^[O"* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
# [[ "$terminfo[khome]" == "^[O"* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
# [[ "$terminfo[kend]" == "^[O"* ]] && bindkey -M viins "${terminfo[kend]/O/[}" end-of-line
# [[ "$terminfo[khome]" == "^[O"* ]] && bindkey -M emacs "${terminfo[khome]/O/[}" beginning-of-line
# [[ "$terminfo[kend]" == "^[O"* ]] && bindkey -M emacs "${terminfo[kend]/O/[}" end-of-line
# fi

# simulate escape key with menu key
bindkey '^[[29~' '^[' noop noop
