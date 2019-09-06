# Shell agnostic env setup

# Important applications.
export EDITOR=vim
export VISUAL=vim
# export BROWSER=google-chrome-stable
# export BROWSER=chrome
export BROWSER=firefox
export TERMINAL=urxvt
export DIFFPROG=meld


# for bspwm reloading
export BSPWM_STATE=/tmp/bspwm-state.json


# for pacmatic
export pacman_program="yay"

# for nnn
export NNN_COPIER="nnn_copier.sh"

# Reduce mode key timeout to 0.1s
export KEYTIMEOUT=1

export PAGER="/usr/bin/less -RF"
# < pager
# export READNULLCMD=less_rfx
export READNULLCMD=bat

# Color for manpages in less makes manpages a little easier to read:
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# Qt toolkit style configuration
export XKB_DEFAULT_LAYOUT=gb
# export QT_QPA_PLATFORMTHEME=qt5ct
# export QT_STYLE_OVERRIDE="adwaita-dark"

# QGtkStyle
# export QT_QPA_PLATFORMTHEME=breeze
# export QT_QPA_PLATFORMTHEME=gtk2

# For polybar weather widget
KEY="fdf4a51d4752e99ecbc7a9ce29967c0c"
CITY="Edinburgh"

