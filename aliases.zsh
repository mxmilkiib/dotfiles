# aliases.zsh: Sets up aliases which make working at the command line easier.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# hacked by milkmiruku - still messy!

# Make sudo expand alises
alias sudo='command sudo '


### Looking around, moving about.

# Graphical tree of subdir files
#alias 'lt=tree -d'

alias ..='cd ..' 		# Automatic in ZSH (default?)
alias ...=../..
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

alias cd..='cd ..'
alias ,,='..'
alias c.='cd $PWD'

# https://github.com/clvv/fasd
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection


# ls colors for filetype recognition
if [[ -x "`whence -p dircolors`" ]]; then
#  eval `dircolors`
 alias ls='ls -F --color=auto'
else
 alias ls='ls -F'
fi

# Alias ls='ls --color'        									# add colors for filetype recognition

alias ll='ls -lh --group-directories-first'     # long list, alphabetical sort (default), human readable (K, M, etc.), directories first

alias lt='ls -ltrh'          										# long list, sort by modification time, reversed (recent last), human readable
alias lu='ls -lturh'         										# long list, sort by and show access time, reversed, human readable
alias lc='ls -ltcrh'         										# long list, sort by and show attribute change time, reversed, human readable
alias lk='ls -lSrh'          										# long list, sort by size, reversed (largest last), human readable

alias la='ls -Atr --group-directories-first'	  # show almost all (hidden files), sort by time, reversed
alias laa='ls -lAh --color | less -RFX'				  # long, almost all, no reverse, piped to less w/ redraw (color), quit if under one screen, don't init/deinit terminal

alias lr='ls -lRh | more'           						# recursive ls
alias lsr='tree -Csu | more '    								# alternative recursive ls

# Mount with coloum output
alias mounts='mount | column -t'


# Search running processes
alias 'ps?'='ps ax | grep '

# Makes parent dir if it doesn't exist (i.e. newdir/secondnewdir/third etc.)
alias mkdir='mkdir -p'

# 'Copy with progress bar'
alias ccp='rsync --progress -ah'


### Shutdown, reboot, logout

# alias slo='sudo killall -u milk'
alias pms='sudo pm-suspend'
alias suspend='pm-suspend' # With sudoers

# systemd
alias sc='systemctl '
alias ssc='sudo systemctl '
alias slo='systemctl restart display-manager' # Logout

alias sd='systemctl poweroff'
alias sr='systemctl reboot'


### Package management

# Aptitude
alias a='sudo aptitude'
alias ai='sudo aptitude install'
alias ar='sudo aptitude remove'
alias au='sudo aptitude update'
alias auu'=sudo aptitude safe-upgrade'
alias as='apt-cache search'
alias aw='apt-cache show'

# Pacman
# alias 'pu=sudo pacman -Syu'
# aurget was tempremental. packer doesn't display as much info as yaourt

alias p='yaourt --noconfirm'
alias pu='yaourt -Syu --noconfirm'

alias pR='sudo pacman -R'										# remove
alias pU='sudo pacman -U'										# upgrade (local package)
alias pL='sudo rm /var/lib/pacman/db.lck'   # remove lockfile if pacman doesn't exit gracefully

# see functions.php for pS (packer search)

# Aurget
alias ags='aurget -Ss'
alias agu='aurget -Syu --deps --noedit --noconfirm'


### Bash

# List ANSI colours
alias colours='for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done'

# For running an app in the background without any stdout in console
alias -g S='&> /dev/null &'

### Zsh
alias sz='source ~/.zshrc'


### Sysadmin

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


### Apps

# Grep, extended-regexp, case insentitive, line number, strip colours control chars for pipes
alias -g G='| grep -Ein --color=tty'

# For quick viewing of txt files
alias -g L='| less -RFX'     # redraw (color), quit under one page, dont init/deinit term

# Open a file
alias o='xdg-open'

# Check Awesome window manager config
alias ak='awesome -k'

# Quick sudo nano
alias sn='sudo nano -c' # With line numbers

# Quick sudo vim (with $EDITOR=vim)
alias sv='sudoedit'

# Vim
alias vg=gvim
alias v='vim --servername VIM'
alias va='vim --remote +split'
alias uv='urxvt -e vim'

# Git
alias gs='git status '
alias gd='git diff --color'
alias gh='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias ga='git add '
alias gaa='git add .'
alias gb='git branch '
# alias gc='git commit' # see functions.zsh for easy git commit
alias go='git checkout '
alias gr='git remote'
alias gp='git push'
alias gpl='git pull'
alias gx='gitx --all'

alias cdg='cd $(git rev-parse --show-cdup)'
# see also gitc in functions.zsh


### Network

# List open ports and their process
alias ports='netstat -plnt'

# Quick local HTTP server
alias server='python2 -m SimpleHTTPServer'
alias serverphp='php -S localhost:8000'

# List connections
alias cons='lsof -i'

# Public IP address
alias publicip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'

# Get shit done - temp redirect certain sites to localhost
alias gsd='sudo /home/milk/scripts/gsd.sh/gsd.sh'


### Web frameworks
alias dr='drush'


### X

# switch to left mouse and back
alias lm='xmodmap -e "pointer = 3 2 1"'
alias ulm='xmodmap -e "pointer = 1 2 3"'


### Misc

# Clear
alias c='clear'

# :q (Vim) as exit
alias :q='exit'

# Bastard Oper From Hell excuse
alias bofh='nc bofh.jeffballard.us 666 | tail -n 1'

# Pipes
alias pipes='nice -n 19 /home/milk/scripts/pipes.sh -R -r 0 -p 3'

# Nyancat
alias nyancat='telnet miku.acm.uiuc.edu'
