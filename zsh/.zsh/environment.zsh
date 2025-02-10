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


XDG_DESKTOP_DIR="$HOME/media/desktop"
XDG_DOCUMENTS_DIR="$HOME/media"
XDG_DOWNLOAD_DIR="$HOME/dl"
XDG_MUSIC_DIR="$HOME/media/audio"
XDG_PICTURES_DIR="$HOME/media/images"
XDG_PUBLICSHARE_DIR="$HOME/sync/public"
XDG_TEMPLATES_DIR="$HOME/media"
XDG_VIDEOS_DIR="$HOME/media/video"
