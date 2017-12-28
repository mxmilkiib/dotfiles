# .zshrc: Configuration for the Z-Shell.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Hacked by milkmiruku

# profiling module. 'zprof' for info.
# zmodload zsh/zprof

# export TERM="xterm-256color"
# export TERM="rxvt-unicode-256color"
# export TERM="rxvt-unicode"
# export TERM="screen-256color" # for tmux backgrond color erase (bce) to work
# let .Xresources do it for xterm for now

# Where everything is.
Z=~/.zsh


# Set some options.
source $Z/options.zsh


# Plugin managament
source $Z/../.zgen/zgen.zsh

# check if there's no init script
if ! zgen saved; then
		echo "Creating a zgen save"

	zgen load unixorn/autoupdate-zgen

	zgen load nojhan/liquidprompt

	zgen load chrissicool/zsh-256color

	zgen load djui/alias-tips

	zgen load zsh-users/zsh-completions

	zgen load RobSis/zsh-completion-generator

	zgen load zsh-users/zsh-history-substring-search

	# zgen load zsh-users/zsh-syntax-highlighting
	zgen load zdharma/fast-syntax-highlighting

	zgen load zsh-users/zsh-autosuggestions
	export ZSH_AUTOSUGGEST_USE_ASYNC=1

	# fzf after zsh-autosuggestions - fzf/issues/227
	zgen load junegunn/fzf
	zgen load junegunn/fzf shell/completion.zsh
	zgen load junegunn/fzf shell/key-bindings.zsh
  # CTRL-T (paste files/dirs), CTRL-R (history), and ALT-C (cd), alias -g F, **<tab>

	zgen save
fi


# Set up a working environment.
source $Z/environment.zsh

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


# https://github.com/clvv/fasd
eval "$(fasd --init auto)"



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

if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    clear
fi

fortune
