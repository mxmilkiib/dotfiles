# aliases.zsh: Sets up aliases which make working at the command line easier.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# hacked by milkmiruku - still messy!

### Gnu

# Make sudo expand alises
alias sudo='command sudo '

# Colors for ls.
if [[ -x "`whence -p dircolors`" ]]; then
  eval `dircolors`
  alias ls='ls -F --color=auto'
else
  alias ls='ls -F'
fi

# Looking around, and moving about.
alias ll='ls -lh'
alias la='ls -lah'

alias ...=../..
alias 'cd..=cd ..'
alias ',,=..'

# Clear
alias 'c=clear'

# Makes parent dir if it doesn't exist
alias 'mkdir=mkdir -p'

# List dir items
alias 'dus=du -ms * | sort -n'

# Graphical tree of subdir files
alias 'lt=tree -d'

# For quick viewing of txt files
alias L=less

# Nano with line numbers
alias 'nano=nano -c'

# Quick sudo nano
alias 'sn=sudo nano -c'

# Quick vim
alias 'v=vim'

# Quick sudo vim (with $EDITOR=vim)
alias 'sv=sudoedit'

# For running an app in the background without any stdout in console
alias -g S='&> /dev/null &'

# Shutdown, reboot
alias 'sd=sudo shutdown -h now'
alias 'sr=sudo reboot'

# Grep, extended-regexp, case insentitive, recursive, line number, strip colours control chars for pipes
alias g="grep -EiRn --color=tty"
alias u="uzbl"

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
alias 'p=sudo pacman -Sy'
alias 'pq=sudo pacman -S'
alias 'pu=sudo pacman -Syu'
alias 'pU=sudo pacman -U'
alias 'pR=sudo pacman -R'

# Aurbuild - http://aurbuild.berlios.de/
alias aurbuild="sudo env EDITOR=\$EDITOR aurbuild --nopager"

### Bash

# List ANSI colours
alias 'colours=for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done'

### To sort

# List open ports and their process
alias 'ports=netstat -plnt'

# Mount with coloum output
alias 'mounts=mount | column -t'

# List connections
alias 'cons=lsof -i'

# Search running processes
alias 'ps?'='ps ax | grep '

# Bastard Oper From Hell excuse
alias bofh='nc bofh.jeffballard.us 666 | tail -n 1'

# Public IP address
alias pip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'

# Git
alias 'gits=git status'
alias 'gita=git add .'
alias 'gitp=git push'
# see also gitc in functions.zsh

# Get shit done - temp redirect certain sites to localhost
alias 'gsd=sudo /home/milk/scripts/get-shit-done/get-shit-done.sh'

# Sudo to aegir user
alias 'sa=sudo -u aegir -i'

# Setup SSHFS access to Aegir's home on thingsandstuff
alias 'sshfsa=sshfs aegir@thingsandstuff.org:/var/aegir /var/aegir -o idmap=user'

# Vim
alias 'vi=vim'
alias 'v=vim'

# Nyancat
alias 'nyancat=telnet miku.acm.uiuc.edu'
