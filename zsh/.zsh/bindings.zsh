# bindings.zsh - hybrid emacs/vim keybindings with terminfo support
# use 'bindkey' to list current key bindings
# run 'bindkey -l' to list available keymaps

# create human readable global associative array from local terminfo in variable $key
# this is instead of hardbinding to control codes as these can vary between terminals
# make sure your terminfo is correct! set in .Xresources. bad idea to overwrite $TERM.
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

# ctrl-left, ctrl-right - terminfo entries often missing, provide fallbacks
key[CtrlLeft]=${terminfo[kLFT5]:-'^[[1;5D'}
key[CtrlRight]=${terminfo[kRFT5]:-'^[[1;5C'}

# f-keys
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

# fix ncurses application mode quirk ($'\eO'* -> $'\e['*)
for k in ${(k)key} ; do
    [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
done
unset k

# enable application keypad mode (allows terminfo keys to work correctly)
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi


# MARK: EMACS MODE BINDINGS (DEFAULT)

# set emacs mode as default
bindkey -e

# enable vim command mode with ESC
bindkey -M emacs '^[' vi-cmd-mode


# MARK: -- navigation

# home/end - beginning/end of line
[[ -n "${key[Home]}" ]] && bindkey -M emacs "${key[Home]}" beginning-of-line
[[ -n "${key[End]}" ]]  && bindkey -M emacs "${key[End]}" end-of-line
bindkey -M emacs '^a' beginning-of-line
bindkey -M emacs '^e' end-of-line
# common terminal variations
bindkey -M emacs '^[[1~' beginning-of-line
bindkey -M emacs '^[[4~' end-of-line
bindkey -M emacs '^[[OH' beginning-of-line
bindkey -M emacs '^[[OF' end-of-line

# arrow keys - basic character movement
[[ -n "${key[Left]}" ]]  && bindkey -M emacs "${key[Left]}" backward-char
[[ -n "${key[Right]}" ]] && bindkey -M emacs "${key[Right]}" forward-char

# page up/down - jump to history boundaries
[[ -n "${key[PageUp]}" ]]   && bindkey -M emacs "${key[PageUp]}" beginning-of-history
[[ -n "${key[PageDown]}" ]] && bindkey -M emacs "${key[PageDown]}" end-of-history

# up/down - history substring search (type then press up/down to search)
[[ -n "${key[Up]}" ]]   && bindkey -M emacs "${key[Up]}" history-substring-search-up
[[ -n "${key[Down]}" ]] && bindkey -M emacs "${key[Down]}" history-substring-search-down
# fallback for terminals not using terminfo
bindkey -M emacs '^[[A' history-substring-search-up
bindkey -M emacs '^[[B' history-substring-search-down

# ctrl-up/ctrl-down - history beginning search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -M emacs '^[[1;5A' history-beginning-search-backward-end
bindkey -M emacs '^[[1;5B' history-beginning-search-forward-end

# ctrl-left/ctrl-right - word movement (emacs style - lands between words)
[[ -n "${key[CtrlLeft]}" ]]  && bindkey -M emacs "${key[CtrlLeft]}" emacs-backward-word
[[ -n "${key[CtrlRight]}" ]] && bindkey -M emacs "${key[CtrlRight]}" emacs-forward-word
# urxvt fallbacks
bindkey -M emacs '\eOd' emacs-backward-word
bindkey -M emacs '\eOc' emacs-forward-word
bindkey -M emacs 'Od' emacs-backward-word
bindkey -M emacs 'Oc' emacs-forward-word
bindkey -M emacs '^[Od' emacs-backward-word
bindkey -M emacs '^[Oc' emacs-forward-word

# alt-left/alt-right - word movement (lands on word boundaries)
bindkey -M emacs '^[[1;3D' backward-word
bindkey -M emacs '^[[1;3C' forward-word
bindkey -M emacs '^[^[[D' backward-word  # urxvt
bindkey -M emacs '^[^[[C' forward-word


# MARK: -- editing

# backspace/delete - character deletion
[[ -n "${key[Backspace]}" ]] && bindkey -M emacs "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}" ]]    && bindkey -M emacs "${key[Delete]}" delete-char

# insert - overwrite mode
[[ -n "${key[Insert]}" ]] && bindkey -M emacs "${key[Insert]}" overwrite-mode

# note: ^H (ctrl-h) conflicts with xterm backspace, so don't bind it
# use ctrl-w instead for backward-kill-word

# ctrl-d - delete char or list completions (default behavior)
bindkey -M emacs '^d' delete-char-or-list

# ctrl-del - delete word forward
bindkey -M emacs '^[[3;5~' kill-word  # xterm
bindkey -M emacs '^[[3^' kill-word    # urxvt

# esc-d / alt-d - delete word forward (standard emacs binding)
bindkey -M emacs '^[d' kill-word

# ctrl-w - delete word backward (standard readline/emacs)
bindkey -M emacs '^w' backward-kill-word

# ctrl-k - delete to end of line
bindkey -M emacs '^k' kill-line

# ctrl-u - delete entire line
bindkey -M emacs '^u' kill-whole-line

# space - do history expansion on space (e.g., !ssh expands)
bindkey -M emacs ' ' magic-space

# shift-tab - reverse menu completion
bindkey -M emacs '\e[Z' reverse-menu-complete

# ctrl-/ (also ctrl-_) - accept completion but keep menu open
bindkey -M emacs '^_' accept-and-hold


## MARK: -- special functions

# f1 - show help for command under cursor
[[ -n "${key[F1]}" ]] && bindkey -M emacs "${key[F1]}" run-help

# f2 - prepend sudo to line
function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
  fi
}
zle -N prepend-sudo
[[ -n "${key[F2]}" ]] && bindkey -M emacs "${key[F2]}" prepend-sudo

# alt-s - insert sudo at beginning (alternate binding)
function insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey -M emacs '^[s' insert-sudo

# f4 - edit command line in $EDITOR
autoload edit-command-line
zle -N edit-command-line
[[ -n "${key[F4]}" ]] && bindkey -M emacs "${key[F4]}" edit-command-line


# MARK: VIM COMMAND MODE BINDINGS

# home/end in vim command mode
[[ -n "${key[Home]}" ]] && bindkey -M vicmd "${key[Home]}" vi-beginning-of-line
[[ -n "${key[End]}" ]]  && bindkey -M vicmd "${key[End]}" vi-end-of-line
bindkey -M vicmd '^[[1~' vi-beginning-of-line
bindkey -M vicmd '^[[4~' vi-end-of-line
bindkey -M vicmd '^[[OH' vi-beginning-of-line
bindkey -M vicmd '^[[OF' vi-end-of-line

# delete in vim command mode
[[ -n "${key[Delete]}" ]] && bindkey -M vicmd "${key[Delete]}" vi-delete-char

# insert mode bindings (when in vi mode)
[[ -n "${key[Home]}" ]] && bindkey -M viins "${key[Home]}" beginning-of-line
[[ -n "${key[End]}" ]]  && bindkey -M viins "${key[End]}" end-of-line
bindkey -M viins '^[[1~' beginning-of-line
bindkey -M viins '^[[4~' end-of-line
bindkey -M viins '^[[OH' beginning-of-line
bindkey -M viins '^[[OF' end-of-line

# arrow keys in vim insert mode
[[ -n "${key[Up]}" ]]    && bindkey -M viins "${key[Up]}" history-substring-search-up
[[ -n "${key[Down]}" ]]  && bindkey -M viins "${key[Down]}" history-substring-search-down
[[ -n "${key[Left]}" ]]  && bindkey -M viins "${key[Left]}" vi-backward-char
[[ -n "${key[Right]}" ]] && bindkey -M viins "${key[Right]}" vi-forward-char

# delete/backspace in vim insert mode
[[ -n "${key[Delete]}" ]]    && bindkey -M viins "${key[Delete]}" delete-char
[[ -n "${key[Backspace]}" ]] && bindkey -M viins "${key[Backspace]}" backward-delete-char

# fix ncurses application mode in vim insert mode
[[ "${key[Up]}" == $'\eO'* ]]    && bindkey -M viins "${key[Up]/O/[}" history-substring-search-up
[[ "${key[Down]}" == $'\eO'* ]]  && bindkey -M viins "${key[Down]/O/[}" history-substring-search-down
[[ "${key[Left]}" == $'\eO'* ]]  && bindkey -M viins "${key[Left]/O/[}" vi-backward-char
[[ "${key[Right]}" == $'\eO'* ]] && bindkey -M viins "${key[Right]/O/[}" vi-forward-char
[[ "${key[Home]}" == $'\eO'* ]]  && bindkey -M viins "${key[Home]/O/[}" beginning-of-line
[[ "${key[End]}" == $'\eO'* ]]   && bindkey -M viins "${key[End]/O/[}" end-of-line
