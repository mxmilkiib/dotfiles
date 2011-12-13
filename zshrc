# .zshrc: Configuration for the Z-Shell.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Hacked by milkmiruku

# export TERM="xterm-256color"
#export TERM="rxvt-unicode-256color"
export TERM="rxvt-unicode"

# Where everything is.
Z=/etc/zsh

# Set up a working environment.
source $Z/environment.zsh

# Set up some aliases
source $Z/aliases.zsh

# Set some options.
source $Z/options.zsh

# Define some functions.
source $Z/functions.zsh

# Set up the Z line editor.
#source $Z/zle.zsh

# Key bindings
source $Z/bindings.zsh

# Set the prompt.
if (( C == 256 )); then
    source $Z/prompt_256.zsh
else
    source $Z/prompt.zsh
fi

# Initialize the completion system.
source $Z/completion.zsh

# Private aliases, etc.
if [ -e $Z/private.zsh ]; then
  source $Z/private.zsh
fi

# Set up colours for ls
if (( C == 256 )); then
  eval `dircolors $Z/dircolors`
fi


