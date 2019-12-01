# Shell agnostic env setup

# Important applications.
export EDITOR=vim
export VISUAL=vim
# export BROWSER=google-chrome-stable
# export BROWSER=chrome
export BROWSER=firefox
export TERMINAL=urxvt
export DIFFPROG=meld

# default pager
export PAGER="/usr/bin/less -RF"
# < pager
#export READNULLCMD=less_rfx
export READNULLCMD=bat


# Color for manpages in less makes manpages a little easier to read:
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# X11
export XKB_DEFAULT_LAYOUT=gb


# Qt toolkit style configuration

# export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORMTHEME=gtk2

# export QT_STYLE_OVERRIDE="adwaita-dark"
# export QT_STYLE_OVERRIDE="breeze"


# pacmatic
export pacman_program="yay"

# nnn
export NNN_COPIER="nnn_copier.sh"

# reduce mode key timeout to 0.1s
export KEYTIMEOUT=1


# bspwm reloading
export BSPWM_STATE=/tmp/bspwm-state.json

# polybar weather widget
KEY="fdf4a51d4752e99ecbc7a9ce29967c0c"
CITY="Edinburgh"

