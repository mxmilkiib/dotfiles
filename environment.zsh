# environment.zsh: Sets up a working shell environment.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# Various Paths
typeset -U path
path=(~/bin $path /usr/local/bin /var/lib/gems/1.8/bin)
export PATH

typeset -U fpath
fpath=($Z/functions $fpath)

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
