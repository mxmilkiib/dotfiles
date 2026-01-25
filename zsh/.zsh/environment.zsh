# environment.zsh: Sets up a working shell environment.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# see also ~/.config/user-dirs.dirs

# https://github.com/paulmars/huffshell
# Various Paths
# typeset -U path
# path=(~/bin $path /usr/local/bin /var/lib/gems/1.8/bin $HOME/.gem/ruby/2.5.0/bin:/home/milk/.cabal/bin) - should be set in /etc/profile
path=(~/bin ~/bin/i3 ~/.local/bin ~/.screenlayout $path)
export PATH

typeset -U fpath
fpath=($Z/functions $Z/zsh-completions/src $fpath)


# https://news.ycombinator.com/item?id=13697555
export TZ=:/etc/localtime


# History Settings
export SAVEHIST=50000
export HISTSIZE=50000
export HISTFILE=~/.zsh_history


export KEYTIMEOUT=30  # 0.5 seconds - more time for ESC-d sequences

# Zsh Reporting
export REPORTTIME=10


C=$(tput colors)
eval $(dircolors $Z/dircolors)

# characters missing from WORDCHARS so deleting words doesn't delete a full path or a hyphen are / =
WORDCHARS='-*?_.[]~&;!#$%^(){}<>'


# pacaur env variables
export LOGDEST=/var/log/pacaur


# OPAM configuration
. /home/milk/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true


# xdg base directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# xdg user directories - source from config file to avoid duplication
[[ -f "$HOME/.config/user-dirs.dirs" ]] && source "$HOME/.config/user-dirs.dirs"
