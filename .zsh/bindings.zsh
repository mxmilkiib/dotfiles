# two thirds through fixing


# Create some blank keymaps to play with. er, what for again?
# bindkey -N sins .safe
# bindkey -N scmd .safe

# to add other keys to this hash, see: man 5 terminfo

# create human readable global associative array from local terminfo in variable $key
# this is instead of hardbinding to control codes as these can vary between terminals
# make sure your terminfo is corrext! set in .Xresources. bad idea to overwrite $TERM.

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

#  'BackTab'      "$terminfo[kcbt]"
# key[Backspace]='^?'
key[CtrlLeft]=${terminfo[kLFT5]}
key[CtrlRight]=${terminfo[kRFT5]}

for k in ${(k)key} ; do
    # $terminfo[] entries are weird in ncurses application mode...
    [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
done
unset k

# setup key accordingly
[[ -n {${key[Home]}}    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode #broken?
[[ -n "${key[Backspace]}" ]]  && bindkey  "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

[[ -n "${key[PageUp]}"  ]]  && bindkey  "${key[PageUp]}"  beginning-of-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-history

[[ -n "${key[CtrlLeft]}" ]]  && bindkey  "${key[CtrlLeft]}" backward-word
[[ -n "${key[CtrlRight]}" ]]  && bindkey  "${key[CtrlRight]}" forward-word


# Ctrl-w - push line to buffer stack, 
bindkey '^w' push-line

# Ctrl-e - pop line from buffer stack
bindkey '^e' get-line


# Ctrl-b - Comment out line with # and execute
bindkey '^b' pound-insert

# bindkey "^V" quoted-insert

# delete after cursor
bindkey "^k" kill-line

# delete everything  
bindkey "^u" kill-whole-line

# clear screen (defauly anyway?)
bindkey "^L" clear-screen

# https://github.com/johan/zsh/blob/master/Functions/Zle/insert-composed-char
autoload insert-composed-char
zle -N insert-composed-char
bindkey "^K" insert-composed-char

# bindkey "^X" execute-named-cmd

# Open man page for command in editing buffer
bindkey $key[F1] run-help

autoload edit-command-line
zle -N edit-command-line
bindkey $key[F2] edit-command-line


bindkey " " magic-space # do history expansion ($ !ssh ...) on space

# bindkey "\e[2~" quoted-insert

# bindkey '^i' expand-or-complete-prefix

# bits from https://github.com/simongmzlj/dotfiles/blob/master/zsh/zshrc

bindkey "\eOc" emacs-forward-word # lands between words, not on first char
bindkey "\eOd" emacs-backward-word

bindkey "\e[Z" reverse-menu-complete # Shift+Tab

# Type command then ctrl-up/ctrl-down to search history
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# bindkey "^S" history-incremental-search-forward
# bindkey "^R" history-incremental-search-backward


bindkey "" backward-delete-word
# bindkey "[3^" delete-word

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
