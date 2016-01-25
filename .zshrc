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

# Key bindings
source $Z/bindings.zsh

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


# Plugin managament
source $Z/zgen.zsh

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

  zgen load unixorn/autoupdate-zgen

  zgen load chrissicool/zsh-256color

  zgen load djui/alias-tips

  zgen load zsh-users/zsh-syntax-highlighting

  zgen load olivierverdier/zsh-git-prompt

  zgen load zsh-users/zsh-completions

  zgen load RobSis/zsh-completion-generator

  zgen load rupa/z

  zgen load zsh-users/zsh-history-substring-search

  zgen load skx/sysadmin-util

  # fzf after zsh-autosuggestions - fzf/issues/227
  zgen load junegunn/fzf

  zgen save
fi

# type then press up/down to search history
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export FZF_DEFAULT_COMMAND='find .'
export FZF_DEFAULT_OPTS='--reverse'
export FZF_TMUX='1'



# https://github.com/clvv/fasd
# eval "$($Z/fasd/fasd --init auto)"


# Set the prompt.
if (( C == 256 )); then
		source $Z/prompt_256.zsh
else
		source $Z/prompt.zsh
fi

# buggy
# zgen load tarruda/zsh-autosuggestions
#
# Enable autosuggestions automatically.
# zle-line-init() {
# 		zle autosuggest-start
# }
# zle -N zle-line-init
