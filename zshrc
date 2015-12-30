# .zshrc: Configuration for the Z-Shell.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Hacked by milkmiruku

# profiling module. 'zprof' for info.
# zmodload zsh/zprof

# export TERM="xterm-256color"
# export TERM="rxvt-unicode-256color"
# export TERM="rxvt-unicode"
export TERM="screen-256color" # for tmux backgrond color erase (bce) to work

# Where everything is.
Z=~/.zsh


# Set up a working environment.
source $Z/environment.zsh

# Set some options.
source $Z/options.zsh


# Set up some aliases
source $Z/aliases.zsh

# Private aliases, etc.
if [ -e $Z/private.zsh ]; then
	source $Z/private.zsh
fi


# Initialize the completion system.
source $Z/completion.zsh

# https://github.com/RobSis/zsh-completion-generator
source $HOME/.zsh/zsh-completion-generator/zsh-completion-generator.plugin.zsh


# Define some functions.
source $Z/functions.zsh


# to fix
# Set up the Z line editor.
# source $Z/zle.zsh

# Key bindings
source $Z/bindings.zsh


# Super git prompt - https://github.com/joto/zsh-git-prompt/blob/master/git-prompt.zsh
source $Z/git-prompt/zshrc.sh

# Set the prompt.
if (( C == 256 )); then
    source $Z/prompt_256.zsh
else
    source $Z/prompt.zsh
fi



# Set up colours for ls
# if (( C == 256 )); then
#   eval `dircolors $Z/dircolors`
# fi

eval $(dircolors -p | sed -e 's/DIR 01;34/DIR 01;36/' | dircolors /dev/stdin)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export FZF_DEFAULT_COMMAND='find .'
export FZF_DEFAULT_OPTS='--reverse'
export FZF_TMUX='1'

# still buggy!!
# source ~/.zsh/zsh-autosuggestions/autosuggestions.zsh
# zle-line-init() {
    # zle autosuggest-start
# }
# zle -N zle-line-init
