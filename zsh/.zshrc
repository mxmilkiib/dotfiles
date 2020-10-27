[ -x bspc ]; bspwm_one_window=$(bspc query --nodes --desktop --node .window | wc -l );
if [ ! $DISPLAY ] || [ $bspwm_one_window = 0 ]; then
  # MOTD - reminder info on readline/emacs/zle binds
  # sleep 0.1
  function echo_color() {
    # printf "\033[0;90m$1\033[0m\n"
    # printf "\033[0;96m$1\033[0m $2 \033[0;96m$3\033[0m $4\n"
    printf "\033[0;96m$1\033[0m $2 \033[0;96m$3\033[0m $4 \033[0;91m$5\033[0m $6 \033[0;91m$7\033[0m $8\n"
  }
  # function echo_color_a() { printf "\033[0;96m$1\033[0m $2 \033[0;96m$3\033[0m $4 \033[0;96m$5\033[0m $6" }
  # function echo_color_a() { printf "\033[0;96m$1\033[0m $2 \033[0;96m$3\033[0m $4 \033[0;91m$5\033[0m $6 \033[0;91m$7\033[0m $8\n" }
  # echo_color "  c-b"  "Move backward character    " "c-f"  "Move forward character"
  # echo_color "  a-b"  "Move backward word end     " "a-f"  "Move forward word end"
  # echo_color "  c-p"  "Move previous (line up)    " "c-n"  "Move next (line down)"
  # echo_color "  c-h"  "Delete backward character  " "c-d"  "Delete forward character"
  # echo_color "  c-w"  "Delete backward word       " "a-d"  "Delete forward word"
  # echo_color "  c-u"  "Delete entire line         " "c-k"  "Delete to end of line"
  # echo_color "  c-a"  "Jump to line beginning     " "c-e"  "Jump to line end"
  echo_color "c-b" "Backward char     "  " c-f" "Forward char    "  " c-h" "delete backward cHar"  " c-d" "delete forwarD char"
  echo_color "a-b" "Backward word end "  " a-f" "Forward word end"  " c-w" "delete backward Word"  " a-d" "delete forwarD word"
  echo_color "c-a" "to stArt of line  "  " c-e" "to End of line  "  " c-k" "Kut to end of line"
  echo_color "c-p" "Previous (line up)"  " c-n" "Next (line down)"  " c-u" "Undo entire line"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# .zshrc: Configuration for the Z-Shell.
# Original by P.C. Shyamshankar
# Hacked by Milky Brewster

# profiling module. 'zprof' for info.
# zmodload zsh/zprof

# export TERM="xterm-256color"
# export TERM="rxvt-unicode-256color"
# export TERM="rxvt-unicode"
# export TERM="screen-256color" # for tmux backgrond color erase (bce) to work
# let .Xresources do it for xterm for now


# Where everything is.
Z=~/.zsh


# Set up shell agnostic working environment.
source ~/.profile

# Set up zsh specific working environment.
source $Z/environment.zsh


# If running from tty1 start sway window manager
# if [ $(tty) = "/dev/tty1" ]; then
 # # export QT_QPA_PLATFORM=wayland-egl
 # # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
 # # export MOZ_ENABLE_WAYLAND=1
 # # export CLUTTER_BACKEND=wayland
 # # export SDL_VIDEODRIVER=wayland
 # # ssh-agent sx
 # # sway -d >~/sway.log 2>&1
# exit 0
# fi

# Auto start tbsm after login on first two VTs
# [[ $XDG_VTNR -le 2 ]] && tdm


# Set some options.
source $Z/options.zsh


# Plugin managament
source /usr/share/zsh/share/zgen.zsh

# check if there's no init script
if ! zgen saved; then
  echo "Creating a zgen save"

  zgen load larkery/zsh-histdb

  zgen load unixorn/autoupdate-zgen

  zgen load nojhan/liquidprompt
  # zgen load romkatv/powerlevel10k powerlevel10k

  zgen load chrissicool/zsh-256color

  zgen load djui/alias-tips

  zgen load zsh-users/zsh-completions

  zgen load RobSis/zsh-completion-generator
    # gencomp ggrep
    # source ~/.zshrc # or run `compinit'
    # ggrep -*[TAB]* -> magic

  zgen load Aloxaf/fzf-tab
  # needs to be sourced after compinit, but before plugins which will wrap widgets like zsh-autosuggestions or fast-syntax-highlighting.

  zgen load zsh-users/zsh-history-substring-search

  # zgen load zsh-users/zsh-syntax-highlighting
  zgen load zdharma/fast-syntax-highlighting

  zgen load zsh-users/zsh-autosuggestions
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  # fzf after zsh-autosuggestions - fzf/issues/227
  # zgen load junegunn/fzf
  # zgen load junegunn/fzf shell/completion.zsh
  # zgen load junegunn/fzf shell/key-bindings.zsh
    # CTRL-T (paste files/dirs), CTRL-R (history), and ALT-C (cd), alias -g F, **<tab>

  zgen save
fi



# Key bindings
source $Z/bindings.zsh

# Initialize the completion system.
# source $Z/completion.zsh

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

bindkey '^m' reset-prompt-and-accept-line
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=reset-prompt-and-accept-line

# launch a tmux session for each terminal. if closed, session persists, and next terminal reconnects.
# if [[ -z "$TMUX" ]] ;then
#     ID="`tmux ls | grep -vm1 attached | cut -d: -f1`"
#     if [[ -z "$ID" ]] ;then
#         tmux new-session
#     else
#         tmux attach-session -t "$ID"
#     fi
# fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  zstyle ':fzf-tab:*' insert-space true
  zstyle ':fzf-tab:*' continuous-trigger '/'
  zstyle ':completion:complete:ls:argument-rest' sort false

# Modal cursor color for vi's insert/normal modes.
# http://stackoverflow.com/questions/30985436/
# https://bbs.archlinux.org/viewtopic.php?id=95078
# http://unix.stackexchange.com/questions/115009/
zle-line-init () {
  zle -K viins
  #echo -ne "\033]12;Grey\007"
  #echo -n 'grayline1'
  echo -ne "\033]12;Gray\007"
  echo -ne "\033[6 q"
  #print 'did init' >/dev/pts/16
}
zle -N zle-line-init
zle-keymap-select () {
  # solid block
  # let &t_EI .= "\<Esc>[1 q"
  # 1 or 0 -> blinking block
  # 3 -> blinking underscore
  # Recent versions of xterm (282 or above) also support
  # 5 -> blinking vertical bar
  # 6 -> solid vertical bar

  if [[ $KEYMAP == vicmd ]]; then
    if [[ -z $TMUX ]]; then
      printf "\033]12;Green\007"
      printf "\033[2 q"
    else
      printf "\033Ptmux;\033\033]12;red\007\033\\"
      printf "\033Ptmux;\033\033[2 q\033\\"
    fi
  else
    if [[ -z $TMUX ]]; then
      printf "\033]12;Grey\007"
      printf "\033[4 q"
    else
      printf "\033Ptmux;\033\033]12;grey\007\033\\"
      printf "\033Ptmux;\033\033[4 q\033\\"
    fi
  fi
  #print 'did select' >/dev/pts/16
}
zle -N zle-keymap-select


# if [ "$TERM" = "linux" ]; then
    # _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    # for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        # echo -en "$i"
    # done
    # clear
# fi


# if [ $(bspc query -N -d|wc -l) = "1" ]; then bspc rule -a \* --one-shot split_dir=south; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

