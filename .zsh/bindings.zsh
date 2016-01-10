# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo

# typeset -g -A key

# key[F1]='^[OP'
# key[F2]='^[OQ'
# key[F3]='^[OR'
# key[F4]='^[OS'
# key[F5]='^[[15~'
# key[F6]='^[[17~'
# key[F7]='^[[18~'
# key[F8]='^[[19~'
# key[F9]='^[[20~'
# key[F10]='^[[21~'
# key[F11]='^[[23~'
# key[F12]='^[[24~'
# key[Backspace]='^?'
# key[Insert]='^[[2~'
# key[Home]='^[[1~'
# key[PageUp]='^[[5~'
# key[Delete]='^[[3~'
# key[End]='^[[4~'
# key[PageDown]='^[[6~'
# key[Up]='^[[A'
# key[Left]='^[[D'
# key[Down]='^[[B'
# key[Right]='^[[C'
# 
# key[CtrlLeft]='\e\e[D'
# key[CtrlRight]='\e\e[C'

#for k in ${(k)key} ; do
#    # $terminfo[] entries are weird in ncurses application mode...
#    [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
#done
#unset k

# setup key accordingly
# [[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
# [[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
# [[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
# [[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
# [[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
# [[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
# [[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
# [[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
# 
# [[ -n "${key[PageUp]}"  ]]  && bindkey  "${key[PageUp]}"  beginning-of-history
# [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-history
# 
# [[ -n "${key[CtrlLeft]}" ]]  && bindkey  "${key[CtrlLeft]}" backward-word
# [[ -n "${key[CtrlRight]}" ]]  && bindkey  "${key[CtrlRight]}" forward-word

bindkey "\e[2~" overwrite-mode
#bindkey "\e[3~" delete-char
bindkey "^[[3~" delete-char

bindkey "\e[1~" beginning-of-line       # urxvt
bindkey "\e[4~" end-of-line             # urxvt

bindkey "\e[OH~" beginning-of-line       # lxterminal
bindkey "\e[OF~" end-of-line             # lxterminal

bindkey "^[OH" beginning-of-line

bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history

#bindkey "\e\e[D" backward-word          # urxvt
#bindkey "\e\e[C" forward-word

#bindkey "\e[1;5D" backward-word		      # lxterminal
#bindkey "\e[1;5C" forward-word

# Ctrl-W - push line to buffer stack, Ctrl-E - pop line from buffer stack
bindkey '^w' push-line
bindkey '^e' get-line

# Ctrl-B - Comment out line with # and execute
bindkey '^b' pound-insert

# key bindings
# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# bindkey "\e[2~" quoted-insert

bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^H" backward-delete-word
# # for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# # for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# # for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# # completion in the middle of a line
# bindkey '^i' expand-or-complete-prefix

# bits from https://github.com/simongmzlj/dotfiles/blob/master/zsh/zshrc

bindkey "^[[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
# # for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# # for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# Type command then ctrl-up/ctrl-down to search history
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo
