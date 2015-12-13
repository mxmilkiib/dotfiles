# environment.zsh: Sets up a working shell environment.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# https://github.com/paulmars/huffshell

# Various Paths
typeset -U path
#path=(~/bin $path /usr/local/bin /var/lib/gems/1.8/bin $HOME/.gem/ruby/1.9.1/bin:/home/milk/.cabal/bin) - should be set in /etc/profile
path=(~/bin $path) 
export PATH

typeset -U fpath
fpath=($Z/functions $fpath)

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-"$HOME/.cache"}

# Find out how many colors the terminal is capable of putting out.
# Color-related settings _must_ use this if they don't want to blow up on less
# endowed terminals.
C=$(tput colors)

# Python per-user site-packages.
#export PYTHONUSERBASE=~

# Python Virtualenvwrapper initialization
#export WORKON_HOME=~/.virtualenvs

# Important applications.
export EDITOR=vim

# History Settings
export SAVEHIST=50000
export HISTSIZE=50000
export HISTFILE=~/.zsh_history
eval `dircolors -b`

# Zsh Reporting
export REPORTTIME=10

# https://github.com/clvv/fasd
eval "$($Z/fasd/fasd --init auto)"

export BSPWM_SOCKET=/tmp/bspwm-socket
PANEL_FIFO=/tmp/panel-fifo

export TMPDIR=/var/tmp

# export PAGER=/usr/bin/vimpager
# alias less=$PAGER
# alias zless=$PAGER
