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

# Initialize the completion system.
source $Z/completion.zsh


# Set up some aliases
source $Z/aliases.zsh

# Private aliases, etc.
if [ -e $Z/private.zsh ]; then
	source $Z/private.zsh
fi

# Define some functions.
source $Z/functions.zsh


# Key bindings
source $Z/bindings.zsh

# plugin managament
source $Z/zgen.zsh

zgen load unixorn/autoupdate-zgen

zgen load chrissicool/zsh-256color

zgen load djui/alias-tips

zgen load zsh-users/zsh-syntax-highlighting

zgen load olivierverdier/zsh-git-prompt

# joto/zsh-git-prompt/

zgen load zsh-users/zsh-completions

zgen load RobSis/zsh-completion-generator

zgen load rupa/z

zgen load zsh-users/zsh-history-substring-search

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

zgen load skx/sysadmin-util

# https://github.com/clvv/fasd
# eval "$($Z/fasd/fasd --init auto)"


# Set the prompt.
if (( C == 256 )); then
		source $Z/prompt_256.zsh
else
		source $Z/prompt.zsh
fi


# fzf after zsh-autosuggestions - fzf/issues/227
zgen load junegunn/fzf

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export FZF_DEFAULT_COMMAND='find .'
export FZF_DEFAULT_OPTS='--reverse'
export FZF_TMUX='1'


# buggy
# zgen load tarruda/zsh-autosuggestions
#
# Enable autosuggestions automatically.
# zle-line-init() {
# 		zle autosuggest-start
# }
# zle -N zle-line-init



# to fix
# Set up the Z line editor.
# source $Z/zle.zsh


# Set up colours for ls
# if (( C == 256 )); then
#   eval `dircolors $Z/dircolors`
# fi

# eval $(dircolors -p | sed -e 's/DIR 01;34/DIR 01;36/' | dircolors /dev/stdin)
