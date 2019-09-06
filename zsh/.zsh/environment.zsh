# environment.zsh: Sets up a working shell environment.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# https://github.com/paulmars/huffshell
# Various Paths
# typeset -U path
# path=(~/bin $path /usr/local/bin /var/lib/gems/1.8/bin $HOME/.gem/ruby/2.5.0/bin:/home/milk/.cabal/bin) - should be set in /etc/profile
path=(~/bin ~/bin/i3 /home/milk/.cargo/bin $path)
# export PATH

typeset -U fpath
fpath=($Z/functions $Z/zsh-completions/src $fpath)


# https://news.ycombinator.com/item?id=13697555
export TZ=:/etc/localtime

# xdg standard
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-"$HOME/.cache"}


# gives fuller GUI 
export XDG_CURRENT_DESKTOP=XFCE

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"


# History Settings
export SAVEHIST=50000
export HISTSIZE=50000
export HISTFILE=~/.zsh_history

# Zsh Reporting
export REPORTTIME=10

export TMPDIR=/var/tmp


C=$(tput colors)
eval $(dircolors $Z/dircolors)

# characters missing from WORDCHARS so deleting words doesn't delete a full path or a hyphen are / =
WORDCHARS='-*?_.[]~&;!#$%^(){}<>'


# pacaur env variables
export LOGDEST=/var/log/pacaur

# npm install -g for user
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules

# OPAM configuration
. /home/milk/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
