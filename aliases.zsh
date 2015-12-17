# aliases.zsh: Sets up aliases which make working at the command line easier.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# hacked by milkmiruku - still messy!

# Make sudo expand alises
alias sudo='command sudo '

# Info on machine
alias wtf='hostname && cat /etc/*-release && whoami && pwd'

# Commands for more info

systemecho='echo history
history info | awk "{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}" | grep -v "./" | column -c3 -s 
w
last -a
uname -a
grep -H  /etc/*release /proc/version
df -h
free -m
who
id
netstat -tlpnu
iptables -nvxL
ss -s
top
ps auxf
dmesg |less
ls -lR /etc/cron*
tail /var/log/*
cat /proc/cpuinfo
lsblk -io KNAME,TYPE,SIZE,MODEL 
findmnt
env'

alias system='echo $systemecho'


### Looking around, moving about.

# ls colors for filetype recognition
if [[ -x "`whence -p dircolors`" ]]; then
 eval `dircolors`
 alias ls='ls -F --color=auto'
else
 alias ls='ls -F'
fi

alias ll="ls -lh --group-directories-first"
# alias ls="ls --color"        # add colors for filetype recognition
alias la="ls -ah"            # show hidden files with human readable sizes

alias lt="ls -ltrh"          # list, sort by date, most recent last, SI unit
alias lc="ls -ltcrh"         # list, sort by and show change time, most recent last
alias lu="ls -lturh"         # list, sort by and show access time, most recent last

alias lk="ls -lSrh"          # sort by size, biggest last

alias lm="ls -alh | more"    # pipe through 'more'
alias lr="ls -lRh"           # recursive ls
alias lsr="tree -Csu | more "    # nice alternative to 'recursive ls'

#alias la='ls -lah'
# Graphical tree of subdir files
#alias 'lt=tree -d'

alias ..="cd .." # Automatic in ZSH (default?)
alias ...=../..
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."

alias 'cd..=cd ..'
alias ',,=..'
alias 'c.=cd $PWD'

# https://github.com/clvv/fasd
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

# Copy with progress bar
# alias cp='rsync --progress -ah'

# Clear
alias 'c=clear'

# Makes parent dir if it doesn't exist
alias 'mkdir=mkdir -p'


### Shutdown, reboot, logout

# alias 'slo=sudo killall -u milk'
alias 'pms=sudo pm-suspend'
alias 'suspend=pm-suspend' # With sudoers

# systemd
alias 'sc=systemctl '
alias 'ssc=sudo systemctl '
alias 'slo=systemctl restart display-manager' # Logout

alias 'sd=systemctl poweroff'
alias 'sr=systemctl reboot'


### Apps

# For running an app in the background without any stdout in console
alias -g S='&> /dev/null &'

# Check Awesome window manager config
alias 'ak=awesome -k'

# Open a file
alias 'o=xdg-open'

# Grep, extended-regexp, case insentitive, line number, strip colours control chars for pipes
alias g="grep -Ein --color=tty"

# For quick viewing of txt files
alias L=less
alias M=more    # does colour

# Quick sudo nano
alias 'sn=sudo nano -c' # With line numbers

# Quick sudo vim (with $EDITOR=vim)
alias 'sv=sudoedit'

# Vim
alias 'vg=gvim'
alias 'vi=vim'
alias 'v=vim'
alias 'uv=urxvt -e vim'

# Web browsers
alias u="uzbl"

# Git
alias 'gits=git status'
alias 'gita=git add .'
alias 'gitd=git diff --color'
alias 'gitps=git push'
alias 'gitpl=git pull'
alias cdg='cd $(git rev-parse --show-cdup)'
# see also gitc in functions.zsh

# Human readable df default
alias 'df=df -h'

# better cdu
alias du2='cdu -idh'

# Check disk usage in ncdu (arch)
alias 'ncdua=ncdu / --exclude /home --exclude /media --exclude /run/media --exclude /boot --exclude /tmp --exclude /dev --exclude /proc'

# List dir items
alias 'dus=du -ms * | sort -n'

# Check disk usage in ncdu (arch root)
alias 'ncduar=sudo ncdu / --exclude /home --exclude /media --exclude /run/media --exclude /boot --exclude /tmp --exclude /dev --exclude /proc --exclude /var/lib/mpd/music'

### Web frameworks
alias 'dr=drush'


### Package management

# Aptitude
alias 'a=sudo aptitude'
alias 'ai=sudo aptitude install'
alias 'ar=sudo aptitude remove'
alias 'au=sudo aptitude update'
alias 'ag=sudo aptitude safe-upgrade'
alias 'as=apt-cache search'
alias 'aw=apt-cache show'

# Pacman
# #alias 'p=packer-color --noedit --noconfirm -S 'tr '[A-Z]' '[a-z]' $1'' - tofix
# alias 'pu=sudo pacman -Syu'
# # alias 'pU=sudo pacman -U'

alias 'p=packer --noconfirm -S'
alias 'pu=packer --noconfirm -Syu'

alias 'pl=sudo rm /var/lib/pacman/db.lck'
alias 'pR=sudo pacman -R'

# see functions.php for pS

# Aurget
alias 'ags=aurget -Ss'
alias 'agu=aurget -Syu --deps --noedit --noconfirm'

# Builds
alias 'cu=sudo chromium-update'


### Bash

# List ANSI colours
alias 'colours=for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done'

### To sort

# List open ports and their process
alias 'ports=netstat -plnt'

# Quick local HTTP server
alias 'server=python2 -m SimpleHTTPServer'
alias 'serverphp=php -S localhost:8000'

# Mount with coloum output
alias 'mounts=mount | column -t'

# List connections
alias 'cons=lsof -i'

# Search running processes
alias 'ps?'='ps ax | grep '

# Pipes
alias pipes="nice -n 19 /home/milk/scripts/pipes.sh -R -r 0 -p 3"

# Bastard Oper From Hell excuse
alias bofh='nc bofh.jeffballard.us 666 | tail -n 1'

# Public IP address
alias publicip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'

# Get shit done - temp redirect certain sites to localhost
alias 'gsd=sudo /home/milk/scripts/gsd.sh/gsd.sh'

# Nyancat
alias 'nyancat=telnet miku.acm.uiuc.edu'

# To let Ubuntu Server know that python2 = python
if [[ "$HOST" != "silver.local" ]] {
  alias 'python2=python'
}

tmux_pwd () {
    [ -z "${TMUX}" ] && return
    tmux set default-path $(pwd) > /dev/null && tmux new-window
    (( sleep 300;
    tmux set default-path ~/ > /dev/null; ) & ) > /dev/null 2>&1
}

alias tpwd="tmux_pwd"
