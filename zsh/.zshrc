# .zshrc: Configuration for the Z-Shell.
# Original by P.C. Shyamshankar
# Hacked by Milky Brewster


function echo_color() {
  printf "\033[0;96m$1\033[0m$2\033[0;96m$3\033[0m$4\033[0;91m$5\033[0m$6\033[0;91m$7\033[0m$8\n"
}

# console message on shell start with reminders of key bindings
# hybrid emacs/vim mode: emacs bindings by default, vim motions after esc
if [[ ${COLUMNS:-80} -le 80 ]]; then
  # compact version for narrow terminals (80 chars or less)
  echo_color "  c-a " "start    " "  c-e " "end      " " Home " "start    " "  End " "end"
  echo_color "  c-k " "kill->   " "  c-u " "kill line" "  c-w " "kill <-  " "  a-d " "kill ->"
  echo_color "c-</> " "jmp word " "a-</> " "jmp word " "  ^v  " "history  " "c-^v  " "hist-pfx"
  echo_color " PgUp " "hist top " "PgDwn " "hist end " "Space " "expand ! " "  ESC " "vi-cmd"
  echo_color "   F1 " "help     " "   F2 " "sudo     " "   F4 " "edit     " "  a-s " "sudo"
  echo_color "  Tab " "complete " "S-Tab " "back cpl " "  c-_ " "keep menu" " c-sp " "run sugg"
  echo_color "  Del " "del char " " BkSp " "del back " "  Ins " "overwrit " "c-Del " "kill ->"
else
  # full version for wider terminals
  echo_color "  c-a "  "Line start         " "  c-e "  "Line end            "  " Home "  "Line start           " "  End "  "Line end"
  echo_color "  c-k "  "Kill to line end   " "  c-u "  "Kill entire line    "  "  c-w "  "Kill word backward   " "  a-d "  "Kill word forward"
  echo_color "c-</> "  "Jump words (emacs) " "a-</> "  "Jump words (vim)    "  "  ^v  "  "Search typed history " "c-^v  "  "Search line start"
  echo_color " PgUp "  "History top        " "PgDwn "  "History end         "  "Space "  "Expand history !     " "  ESC "  "Vim command mode"
  echo_color "   F1 "  "Help on command    " "   F2 "  "Prepend sudo        "  "   F4 "  "Edit in $EDITOR      " "  a-s "  "Insert sudo"
  echo_color "  Tab "  "Completion         " "S-Tab "  "Reverse completion  "  "  c-_ "  "Keep menu open       " " c-sp "  "Run suggestion"
  echo_color "  Del "  "Delete char        " " BkSp "  "Delete backward     "  "  Ins "  "Overwrite mode       " "c-Del "  "Kill word forward"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
# source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# profiling module. 'zprof' for info.
# zmodload zsh/zprof


# Plugin managament with zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
# [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
# source <(curl -sL init.zshell.dev); zzinit


# Where everything is.
Z=~/.zsh


# Set up shell agnostic working environment.
source ~/.profile

# Set up zsh specific working environment.
source $Z/environment.zsh

# Set some options.
source $Z/options.zsh


# load plugins

# zsh-histdb: SQLite-based command history with directory tracking
# stores command start/stop times, working directory, hostname, session ID, exit status
# commands:
#   histdb [term]          - search history (use % as wildcard, e.g., histdb git%commit)
#   histdb --help          - show all search options (filter by host, dir, session, time)
#   histdb-top             - show most frequent commands
#   histdb-top dir         - show most used directories
#   histdb --host hostname - filter by specific host
#   histdb -s 522          - show specific session number
# config:
#   HISTORY_IGNORE='(ls|cd|top|htop)' - glob pattern to exclude commands from history
# database location: ~/.histdb/zsh-history.db
zi load larkery/zsh-histdb

# liquidprompt: adaptive prompt showing git status, load, battery, etc.
# automatically adjusts based on terminal width and system state
zi load nojhan/liquidprompt
# zi load romkatv/powerlevel10k powerlevel10k

# zsh-256color: enables 256 color support in terminal
# provides $FG, $BG, $FX arrays for colors (e.g., $FG[214] for orange)
zi load chrissicool/zsh-256color

# alias-tips: shows existing alias when typing full command
# helps learn and remember defined aliases
zi load djui/alias-tips

# zsh-completions: additional completion definitions for common commands
# provides tab completions for commands not covered by default zsh
# zi wait lucid atload"zicompinit; zicdreplay" blockf for \
zi load zsh-users/zsh-completions

# autoload -Uz _zi
# (( ${+_comps} )) && _comps[zi]=_zi

# zsh-completion-generator: auto-generate completions from --help output
# usage: gencomp <command> - creates completion for command
# example: gencomp ggrep, then ggrep -*[TAB]* works
zi load RobSis/zsh-completion-generator
# gencomp ggrep
# source ~/.zshrc # or run `compinit'
# ggrep -*[TAB]* -> magic
# autoload -Uz compinit
# compinit
# zi cdreplay -q

# zsh-reentry-hook: runs hooks when returning to shell prompt
# used by other plugins to detect terminal re-entry
zi load RobSis/zsh-reentry-hook



# zi pack"default+keys" for fzf

# [ "${DISPLAY:+X11}${WAYLAND_DISPLAY:+WAYLAND}" ] && zi light laggardkernel/zsh-tmux
# zi load laggardkernel/zsh-tmux

# zsh-fzf-history-search: fuzzy search command history with preview
# ctrl-r: open FZF history search (interactive fuzzy finder)
zi light joshskidmore/zsh-fzf-history-search

# fzf-tab: replace tab completion with FZF fuzzy finder
# tab: opens FZF menu for completions, ctrl-/: toggle preview
# needs to be sourced after compinit, but before plugins which will wrap widgets like zsh-autosuggestions or fast-syntax-highlighting.
zi load Aloxaf/fzf-tab

# history-substring-search: search history by substring
# up/down arrows: search history matching typed text (anywhere in command)
# ctrl-up/ctrl-down: search matching from start of line only
zi load zsh-users/zsh-history-substring-search

  # fast-syntax-highlighting: real-time syntax highlighting as you type
  # highlights commands green (valid) or red (invalid), strings, paths, etc.
  # zi load zsh-users/zsh-syntax-highlighting
  # zi load zdharma/fast-syntax-highlighting
  zi load zdharma-continuum/fast-syntax-highlighting

  # zsh-autosuggestions: suggests commands from history as you type
  # ctrl-space: execute suggestion, right-arrow/end: accept suggestion
  # alt-f: accept next word of suggestion
  zi load zsh-users/zsh-autosuggestions
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  # fzf after zsh-autosuggestions - fzf/issues/227
  # zi load junegunn/fzf
  # zi load junegunn/fzf shell/completion.zsh
  # zi load junegunn/fzf shell/key-bindings.zsh
  # CTRL-T (paste files/dirs), CTRL-R (history), and ALT-C (cd), alias -g F, **<tab>

  # zsh-z: jump to frecent directories (frequency + recency)
  # usage: z <partial-name> - jump to most used/recent matching directory
  # example: z dot -> cd ~/dotfiles (if frequently used)
  zi load agkozak/zsh-z


# fzf: command-line fuzzy finder for files, history, processes
# ctrl-t: paste selected files/directories, ctrl-r: search history
# alt-c: cd into selected directory, **<TAB>: trigger FZF completion
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)


# Key bindings
source $Z/bindings.zsh

# Initialize the completion system.
source $Z/completion.zsh

# Set up some aliases and functions
source $Z/aliasesfunctions.zsh

# Private aliases, etc.
if [ -e $Z/private.zsh ]; then
  source $Z/private.zsh
fi


# Bell on command completion, used for urgent flagging
source $Z/zbell.sh

# FZF settings
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND="fd --hidden --exclude '.git' --exclude 'node_modules'"
export FZF_COMPLETION_TRIGGER='**'
export FZF_COMPLETION_OPTS='+c -x'
export FZF_DEFAULT_OPTS='--reverse'
export FZF_TMUX='1'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}


## Autojump
if command -v pazi &>/dev/null; then
  eval "$(pazi init zsh)" # or 'bash'
fi


# ctrl-space executes the autosuggestion
bindkey '^ ' autosuggest-execute

# update prompt time when pressing return to launch a command
reset-prompt-and-accept-line() {
zle reset-prompt
zle accept-line
}
zle -N reset-prompt-and-accept-line


# don't execute but stash in the command history
bindkey '^m' reset-prompt-and-accept-line
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=reset-prompt-and-accept-line


zstyle ':fzf-tab:*' insert-space true
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':completion:complete:*:argument-rest' sort false
zstyle ':completion:*' file-sort modification


# Modal cursor color for vi's insert/normal modes.
# http://stackoverflow.com/questions/30985436/
# https://bbs.archlinux.org/viewtopic.php?id=95078
# http://unix.stackexchange.com/questions/115009/
# zle-line-init () {
# zle -K viins
# #echo -ne "\033]12;Grey\007"
# #echo -n 'grayline1'
# echo -ne "\033]12;Gray\007"
# echo -ne "\033[6 q"
# #print 'did init' >/dev/pts/16
# }
# zle -N zle-line-init
#
# zle-keymap-select () {
# # solid block
# # let &t_EI .= "\<Esc>[1 q"
# # 1 or 0 -> blinking block
# # 3 -> blinking underscore
# # Recent versions of xterm (282 or above) also support
# # 5 -> blinking vertical bar
# # 6 -> solid vertical bar
#
# if [[ $KEYMAP == vicmd ]]; then
#   if [[ -z $TMUX ]]; then
#     printf "\033]12;Green\007"
#     printf "\033[2 q"
#   else
#     printf "\033Ptmux;\033\033]12;red\007\033\\"
#     printf "\033Ptmux;\033\033[2 q\033\\"
#   fi
# else
#   if [[ -z $TMUX ]]; then
#     printf "\033]12;Grey\007"
#     printf "\033[4 q"
#   else
#     printf "\033Ptmux;\033\033]12;grey\007\033\\"
#     printf "\033Ptmux;\033\033[4 q\033\\"
#   fi
# fi
# #print 'did select' >/dev/pts/16
# }
# zle -N zle-keymap-select


# launch a tmux session for each terminal. if closed, session persists, and next terminal reconnects.
# if [[ -z "$TMUX" ]] ;then
#     ID="`tmux ls | grep -vm1 attached | cut -d: -f1`"
#     if [[ -z "$ID" ]] ;then
#         tmux new-session
#     else
#         tmux attach-session -t "$ID"
#     fi
# fi


# if [ "$TERM" = "linux" ]; then
# _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
# for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
# echo -en "$i"
# done
# clear
# fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# [[ ! -f ~/.config/awesome/awesomewm-vim-tmux-navigator/dynamictitles.zsh ]] || source ~/.config/awesome/awesomewm-vim-tmux-navigator/dynamictitles.zsh

# cursor color to indicate vi mode (cyan in vicmd, default in insert/emacs)
# https://unix.stackexchange.com/questions/743104/colorful-cursor-to-indicate-vi-mode-in-zsh-but-fail-to-reset-color
_reset_cursor_color() printf '\e]112\a'

zle-keymap-select() {
    # set VIMODE variable for prompt (if using custom prompt that displays it)
    VIMODE="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    
    # change cursor color based on mode
    if [[ $KEYMAP = vicmd ]]; then
        printf '\e]12;#0ff\a'  # cyan cursor in vim command mode
    else
        _reset_cursor_color    # default cursor in emacs/insert mode
    fi
    
    zle reset-prompt
}
zle -N zle-keymap-select

precmd_functions+=(_reset_cursor_color)

# re-bind ESC to vim command mode (in case plugins override it)
bindkey -M emacs '^[' vi-cmd-mode

