# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo

typeset -g -A key

key[F1]='^[OP'
key[F2]='^[OQ'
key[F3]='^[OR'
key[F4]='^[OS'
key[F5]='^[[15~'
key[F6]='^[[17~'
key[F7]='^[[18~'
key[F8]='^[[19~'
key[F9]='^[[20~'
key[F10]='^[[21~'
key[F11]='^[[23~'
key[F12]='^[[24~'
key[Backspace]='^?'
key[Insert]='^[[2~'
key[Home]='^[[1~'
key[PageUp]='^[[5~'
key[Delete]='^[[3~'
key[End]='^[[4~'
key[PageDown]='^[[6~'
key[Up]='^[[A'
key[Left]='^[[D'
key[Down]='^[[B'
key[Right]='^[[C'

key[CtrlLeft]='\e\e[D'
key[CtrlRight]='\e\e[C'

#for k in ${(k)key} ; do
#    # $terminfo[] entries are weird in ncurses application mode...
#    [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
#done
#unset k

#bindkey "\e[1~" beginning-of-line
#bindkey "\e[4~" end-of-line


# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

[[ -n "${key[PageUp]}"  ]]  && bindkey  "${key[PageUp]}"  beginning-of-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-history

[[ -n "${key[CtrlLeft]}" ]]  && bindkey  "${key[CtrlLeft]}" backward-word
[[ -n "${key[CtrlRight]}" ]]  && bindkey  "${key[CtrlRight]}" forward-word



