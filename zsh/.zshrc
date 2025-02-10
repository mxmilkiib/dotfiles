# .zshrc: Configuration for the Z-Shell.
# Original by P.C. Shyamshankar
# Hacked by Milky Brewster


function echo_color() {
  printf "\033[0;96m$1\033[0m$2\033[0;96m$3\033[0m$4\033[0;91m$5\033[0m$6\033[0;91m$7\033[0m$8\n"
}

# console message on shell start with reminders of the "readline" hotkeys
# function echo_color_a() { printf "\033[0;96m$1\033[0m $2 \033[0;96m$3\033[0m $4 \033[0;91m$5\033[0m $6 \033[0;91m$7\033[0m $8\n" }
echo_color " c-b "  "Back one character " "c-f "  "Forward a character "  "c-h "  "Delete back a character " "c-d "  "Delete a character"
echo_color " a-b "  "Back to word end   " "a-f "  "Forward to word end "  "c-w "  "Delete back a word      " "a-d "  "Delete forward a word"
echo_color " c-p "  "Up one line        " "c-n "  "Down one line       "  "c-k "  "Delete to end of line   " "c-u "  "Delete entire line"
echo_color " c-a "  "Go to line start   " "c-e "  "Jump to line end"
# echo_color "C-b" "Back char     " "C-f" "Forward char    "  "C-h" "del back cHar"  " C-d" "del forwarD char"
# echo_color "A-b" "Back word end " "A-f" "Forward word end"  "C-w" "del back Word"  " A-d" "del forwarD word"
# echo_color "C-a" "to line stArt " "C-e" "to End of line  "  "C-k" "Kut to lineend"
# echo_color "C-p" "Prev (line up)" "C-n" "Next (line down)"  "C-u" "Undo line"

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

zi load larkery/zsh-histdb

zi load nojhan/liquidprompt
# zi load romkatv/powerlevel10k powerlevel10k

zi load chrissicool/zsh-256color

zi load djui/alias-tips

# zi wait lucid atload"zicompinit; zicdreplay" blockf for \
zi load zsh-users/zsh-completions

# autoload -Uz _zi
# (( ${+_comps} )) && _comps[zi]=_zi

zi load RobSis/zsh-completion-generator
# gencomp ggrep
# source ~/.zshrc # or run `compinit'
# ggrep -*[TAB]* -> magic
# autoload -Uz compinit
# compinit
# zi cdreplay -q

zi load RobSis/zsh-reentry-hook



# zi pack"default+keys" for fzf

# [ "${DISPLAY:+X11}${WAYLAND_DISPLAY:+WAYLAND}" ] && zi light laggardkernel/zsh-tmux
# zi load laggardkernel/zsh-tmux

# zsh-fzf-history-search
# zi wait lucid for '0'
zi light joshskidmore/zsh-fzf-history-search
# ctrl-r

# needs to be sourced after compinit, but before plugins which will wrap widgets like zsh-autosuggestions or fast-syntax-highlighting.
zi load Aloxaf/fzf-tab

zi load zsh-users/zsh-history-substring-search

  # zi load zsh-users/zsh-syntax-highlighting
  # zi load zdharma/fast-syntax-highlighting
  zi load zdharma-continuum/fast-syntax-highlighting

  zi load zsh-users/zsh-autosuggestions
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  # fzf after zsh-autosuggestions - fzf/issues/227
  # zi load junegunn/fzf
  # zi load junegunn/fzf shell/completion.zsh
  # zi load junegunn/fzf shell/key-bindings.zsh
  # CTRL-T (paste files/dirs), CTRL-R (history), and ALT-C (cd), alias -g F, **<tab>

  zi load agkozak/zsh-z


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

# https://unix.stackexchange.com/questions/743104/colorful-cursor-to-indicate-vi-mode-in-zsh-but-fail-to-reset-color
_reset_cursor_color() printf '\e]112\a'

zle-keymap-select() {
    if [[ $KEYMAP = vicmd ]]; then
        printf '\e]12;#0ff\a'
    else
        _reset_cursor_color
    fi
}
zle -N zle-keymap-select

zle-line-init() zle -K viins
zle -N zle-line-init

precmd_functions+=(_reset_cursor_color)

