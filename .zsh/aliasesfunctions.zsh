 # Aliases plus functions and their invocations
# milk <dotconfig@milkmiruku.com>
# sourced from various including P.C. Shyamshankar <sykora@lucentbeing.com>

### Shell

# http://lucentbeing.com/writing/archives/a-guide-to-256-color-codes/
if (( C == 256 )); then
		autoload spectrum && spectrum # Set up 256 color support.
fi

# Resource zsh config
alias sz='source ~/.zshrc'

# Clear
alias c='clear'

# :q (Vim) as exit
alias :q='exit'

function zle-keymap-select {
		VIMODE="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
		zle reset-prompt
}

zle -N zle-keymap-select

# IRC client like buffer push new lines into the history stack and recall later
# broken??.
fake-accept-line() {
	# If the Zle buffer is not empty
	if [[ -n "$BUFFER" ]];
	then
		# Print the buffer silently
		print -S "$BUFFER"
#    zle .send-break
	fi
	return 0
}

zle -N fake-accept-line

down-or-fake-accept-line() {
	# If history line number equals the history line number of the
	if (( HISTNO == HISTCMD )) && [[ "$RBUFFER" != *$'\n'* ]];
	then
		zle fake-accept-line
	fi
	zle .down-line-or-history "$@"
}

zle -N down-or-fake-accept-line

zle -N down-line-or-history down-or-fake-accept-line

# Print text normally, in color 214, which happens to be a nice orange.
#$> echo "$FG[214]Hello, World"
# Make the same text bold.
#$> echo "$FX[bold]$FG[214]Hello, World"
# Print underlined and italicized text, with normal foreground, and blue
# background.
#$> echo "$FX[italic]$FX[underline]$BG[020]Hello, World"
# Bold, blinking purple text.
#$> echo "$FX[bold]$FX[blink]$FG[093]Hello, World"
# Simple purple text on yellow background.
#$> echo "$FG[093]$BG[226]Hello, World"


# Autoload some useful utilities.

# http://onethingwell.org/post/24608988305/zmv
# autoload -Uz zmv

# https://github.com/johan/zsh/blob/master/Functions/Misc/zargs
# autoload -Uz zargs


### Terminal multiplexing

# Check if there is an existing tmux server
function ctmux(){
	CTMUXC="$(tmux ls 2>&1 >/dev/null)"
				if [[ $CTMUXC = "server not found: Connection refused" ]]; then
		tmux -2
	else
		tmux -2 attach
	fi
	zsh
}


### Admin

# Make sudo expand alises
alias sudo='command sudo '

# Change to root with users environment
alias se="sudo -E $SHELL"

# Redo last line with sudo
alias pls='sudo $(fc -ln -1)'

# Quick command name kill
alias ska='sudo killall'

# Check if command exists
command_exists () {
		type "$1" &> /dev/null ;
}

# Search running processes
alias 'ps?'='ps ax | grep '

# info trumps man feature-wise, new hotkeys to learn
# alias man='info'

# Basic machine details
alias wtf='hostname && cat /etc/*-release && whoami && pwd'

# Echo a list of handy commands for info
alias system='echo $systemecho'

systemecho='echo # here are some tools to try
# echo global and local variables
export
env
set
history info | awk "{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}" | grep -v "./" | column -c3 -s
w
# who is logged in on what tty, etc.
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
env
history
# see command history'


### Looking and moving around

# ls colors for filetype recognition
if [[ -x "`whence -p dircolors`" ]]; then
#  eval `dircolors`
 alias ls='ls -F --color=auto'
else
 alias ls='ls -F'
fi

# Alias ls='ls --color'        									# add colors for filetype recognition

alias ll='ls -lh --group-directories-first'     # long list, alphabetical sort (default), human readable (K, M, etc.), directories first
alias lla='ls -lha --group-directories-first'     # long list, alphabetical sort (default), human readable (K, M, etc.), directories first

alias lt='ls -ltrh'          										# long list, sort by modification time, reversed (recent last), human readable
alias lu='ls -lturh'         										# long list, sort by and show access time, reversed, human readable
alias lc='ls -ltcrh'         										# long list, sort by and show attribute change time, reversed, human readable
alias lk='ls -lSrh'          										# long list, sort by size, reversed (largest last), human readable

alias la='ls -A --group-directories-first'      # show almost all (hidden files)
alias lat='ls -Atr --group-directories-first'	  # show almost all (hidden files), sort by time, reversed
alias laa='ls -lAh --color | less -RFX'				  # long, almost all, no reverse, piped to less w/ redraw (color), quit if under one screen, don't init/deinit terminal

alias lr='ls -lRh | "$PAGER"'           						# recursive ls
alias lsr='tree -Csu | less -RFX'    								# alternative recursive ls

# Graphical tree of subdir files
#alias 'lt=tree -d'

# Search in files
function gcode() { grep --color=always -rnC3 -- "$@" . | /usr/bin/less -R; }

# Mount with coloum output
alias mounts='mount | column -t'

# Human readable df default
alias 'df=df -h'

# better cdu
alias du2='cdu -idh'

# List dir items
alias 'dus=du -ms * | sort -n'

# Check disk usage in ncdu (arch root)
alias 'ncduar=sudo ncdu / --exclude /home --exclude /media --exclude /run/media --exclude /boot --exclude /tmp --exclude /dev --exclude /proc --exclude /var/lib/mpd/music --exclude /run/user'


alias ..='cd ..' 		# Automatic in ZSH (default?)
alias ...=../..
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

alias cd..='cd ..'
alias ,,='..'
alias c.='cd $PWD'

#to fox
alias cppwd='export CPPWD=$(pwd)'
alias gopwd='cd $CPPWD'

# https://github.com/clvv/fasd
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

# lwd - jump back to last dir of previous terminal
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/last-working-dir/last-working-dir.plugin.zsh
typeset -g ZSH_LAST_WORKING_DIRECTORY
cache_file="$Z/cache/$HOST/last-working-dir"

# Updates the last directory once directory is changed.
chpwd_functions+=(chpwd_last_working_dir)
function chpwd_last_working_dir() {
	# Use >| in case noclobber is set to avoid "file exists" error
	pwd >| "$cache_file"
}

# Changes directory to the last working directory.
function lwd() {
	[[ ! -r "$cache_file" ]] || cd "`cat "$cache_file"`"
}

# Automatically jump to last working directory unless this isn't the first time
# this plugin has been loaded.
# if [[ -z "$ZSH_LAST_WORKING_DIRECTORY" ]]; then
	# lwd 2>/dev/null && ZSH_LAST_WORKING_DIRECTORY=1 || true
# fi

# Browse path web browser like
function up() { pushd .. > /dev/null; }
function down() { popd > /dev/null; }

# make and change into new directory
function md() { mkdir -p "$1" && cd "$1"; }

# Follow copied and moved files to destination directory
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }

# Change into directory and long list files combo
cl() { cd "$1" && ll . ; }

# Makes parent dir if it doesn't exist (i.e. newdir/secondnewdir/third etc.)
alias mkdir='mkdir -p'

# Quick remove directory
alias rd='rm -rf'


### Network

# Ping and traceroute combo
alias mtr="mtr -b -z -o LSDRNABWVGJMXI"
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

#
sshping() {
   while sleep 0.5; do
     nc -vv -w 1 -z ${1:-localhost} ${2:-22}
   done
}

### Shutdown, reboot, logout

# alias slo='sudo killall -u milk'
alias pms='sudo pm-suspend'
alias suspend='pm-suspend' # With sudoers

# systemd
alias sy='systemctl '
alias ssc='sudo systemctl '
# alias slo='systemctl restart display-manager' # Logout
alias slo='sudo killall -u `whoami`' # Logout

alias sd='systemctl poweroff'
alias sr='systemctl reboot'


### Package management

# Debian derived
alias a='sudo aptitude'
alias ai='sudo aptitude install'
alias ar='sudo aptitude remove'
alias au='sudo aptitude update'
alias auu'=sudo aptitude safe-upgrade'
alias as='apt-cache search'
alias aw='apt-cache show'

# Arch Linux
alias p='yaourt -S --noconfirm'
alias pSu='yaourt --noconfirm $_'

# alias 'pu=sudo pacman -Syu'
alias pu='yaourt -Syu --noconfirm'
function pS(){
	yaourt --noconfirm --color --pager $@
}
alias y='yaourt'

alias pQi='yaourt -Qi'
alias pQl='yaourt -Ql'
alias pQo='yaourt -Qo'

alias pR='sudo pacman -R'										# remove
alias pU='sudo pacman -U'										# upgrade (local package)
alias pL='sudo rm /var/lib/pacman/db.lck'   # remove lockfile if pacman doesn't exit gracefully
alias pG='yaourt -G'
alias mP='makepkg -si'

# Aurget - AUR helper. notes; was intermittant
# alias ags='aurget -Ss'
# alias agu='aurget -Syu --deps --noedit --noconfirm'
# aurget was tempremental. 

# Easy Aurget
function aurge(){
	local pretmp=$PWD
	cd /tmp/
	aurget -Sy "$@" --deps --noedit;
	cd $pretmp
}

# packer - doesn't display as much info as yaourt
# Clour pacman/packer search output. tl;dr - use yaourt
# pS() {
# 	local CL='\\e['
# 	local RS='\\e[0;0m'
# 
# 	echo -e "$(packer -Ss "$@" | sed "
# 		/^core/		s,.*,${CL}1;31m&${RS},
# 		/^extra/	s,.*,${CL}0;32m&${RS},
# 		/^community/	s,.*,${CL}1;35m&${RS},
# 		/^[^[:space:]]/	s,.*,${CL}0;36m&${RS},
# 	  ")"
# }


### Utils

# Grep, extended-regexp, case insentitive, line number, strip colours control chars for pipes
alias -g G='| grep -Ein --color=tty'

# For quick viewing of txt files
alias l='less -RFX'
alias -g L='| less -RFX'     # redraw (color), quit under one page, dont init/deinit term
# alias -g "<"='less -RFX'

# for READNULLCMD in environment.zsh
function less_rfx() {
	less -RFX "$@"
}

# List ANSI colours
alias colours='for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done'

# For running an app in the background without any stdout in console
alias -g S='&> /dev/null &'

# 'Copy with progress bar'
alias ccp='rsync --progress -ah'


### Apps

# with both in and out
alias alsamixer='alsamixer -V=all'

# Open a file
alias o='xdg-open'

# Quick file manager
alias fm='thunar'

# Check Awesome window manager config
alias ak='awesome -k'

# Quick sudo nano
alias sn='sudo nano -c' # With line numbers

# Quick sudo vim (with $EDITOR=vim)
alias sv='sudoedit'
compdef sv=sudoedit

# Vim
alias vg='gvim '
alias v='vim '
# alias v='vim --servername VIM'
# alias va='vim --remote +split'
alias uv='urxvt -e vim'

# Git
alias gs='git status '
alias gd='git diff --color'
alias gdc='git diff --color --cached'
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

# Easy Git commit
function gc(){
	git commit -m "$*";
}

alias cdg='cd $(git rev-parse --show-cdup)'
# see also gitc in functions.zsh

# Color diff
diff () {
	if command_exists colordiff ; then
		colordiff "$@" | less -R
	else
		command diff "$@a" | less
	fi
}

# Extract content from an archive
ext() {
	if [ -f $1 ] ; then
			case $1 in
					*.tar.bz2)   tar xvjf $1    ;;
					*.tar.gz)    tar xvzf $1    ;;
					*.tar.xz)    tar xvJf $1    ;;
					*.bz2)       bunzip2 $1     ;;
					*.rar)       unrar x $1     ;;
					*.gz)        gunzip $1      ;;
					*.tar)       tar xvf $1     ;;
					*.tbz2)      tar xvjf $1    ;;
					*.tgz)       tar xvzf $1    ;;
					*.zip)       unzip $1       ;;
					*.Z)         uncompress $1  ;;
					*.7z)        7z x $1        ;;
					*.iso)       7z x $1        ;;
					*.xz)        unxz $1        ;;
					*.exe)       cabextract $1  ;;
					*)           echo "\`$1': unrecognized file compression" ;;
			esac
	else
			echo "\`$1' is not a valid file"
	fi
}


# Etymology
function etym(){
		for term in "$@"
		do
				url="etymonline.com/index.php?term=$term"
				curl -s $url | grep "<dd " |
								sed -e 's/<a[^>]*>\([^<]*\)<[^>]*>/:\1:/g' -e 's/<[^>]*>//g' |
								fold -sw `[ $COLUMNS -lt 80 ] && echo $COLUMNS || echo 79 `
				echo
		done
}

# get_iplayer radio
function gr() { get_iplayer -g --modes=flashaacstd --pid=$1; }

function headless(){
	VBoxHeadless -startvm "$@" &
}

# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
cb() {
	local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
	# Check that xclip is installed.
	if ! type xclip > /dev/null 2>&1; then
		echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
	# Check user is not root (root doesn't have access to user xorg server)
	elif [[ "$USER" == "root" ]]; then
		echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
	else
		# If no tty, data should be available on stdin
		if ! [[ "$( tty )" == /dev/* ]]; then
			input="$(< /dev/stdin)"
		# Else, fetch input from params
		else
			input="$*"
		fi
		if [ -z "$input" ]; then  # If no input, print usage message.
			echo "Copies a string to the clipboard."
			echo "Usage: cb <string>"
			echo "       echo <string> | cb"
		else
			# Copy input to clipboard
			echo -n "$input" | xclip -selection c
			# Truncate text for status
			if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
			# Print status.
			echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
		fi
	fi
}

# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }
# Copy SSH public key
alias cbssh="cb ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbwd="pwd | cb"
# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"


precmd() { [[ -t 0&&  -w 0 ]]&&  print -Pn '\e]2;%~\a' }

scan() {
	if [[ -z $1 || -z $2 ]]; then
		echo "Usage: $0 <host> <port, ports, or port-range>"
		return
	fi

	local host=$1
	local ports=()
	case $2 in
		*-*)
			IFS=- read start end <<< "$2"
			for ((port=start; port <= end; port++)); do
				ports+=($port)
			done
			;;
		*,*)
			IFS=, read -ra ports <<< "$2"
			;;
		*)
			ports+=($2)
			;;
	esac


	for port in "${ports[@]}"; do
		alarm 1 "echo >/dev/tcp/$host/$port" &&
			echo "port $port is open" ||
			echo "port $port is closed"
	done
}


# http://stackoverflow.com/a/187853
# URL encode something and print it.
function url-encode; {
				setopt extendedglob
				echo "${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]}"
}

# Search google for the given keywords.
function google; {
				$BROWSER "http://www.google.com/search?q=`url-encode "${(j: :)@}"`" 1> /dev/null
}


### Web frameworks
alias dr='drush'


### X

# switch to left mouse and back
alias lm='xmodmap -e "pointer = 3 2 1"'
alias ulm='xmodmap -e "pointer = 1 2 3"'

# Reset desktops for two screen 1280x1024
alias xrandrr="xrandr --output DVI-I-1 --mode 1280x1024 --pos 0x0 --panning 0x0+0+0 --output DVI-I-0 --mode 1280x1024 --pos 1280x0"

# Reload compton
alias comptonrl='sudo killall compton; compton -b'


### Misc

# Bastard Oper From Hell excuse
alias bofh='nc bofh.jeffballard.us 666 | tail -n 1'

# Pipes
alias pipes='nice -n 19 /home/milk/scripts/pipes.sh -R -r 0 -p 3'

# Nyancat
alias nyancat='telnet nyancat.dakko.us'


function most_useless_use_of_zsh {
	 local lines columns colour a b p q i pnew
	 ((columns=COLUMNS-1, lines=LINES-1, colour=0))
	 for ((b=-1.5; b<=1.5; b+=3.0/lines)) do
			 for ((a=-2.0; a<=1; a+=3.0/columns)) do
					 for ((p=0.0, q=0.0, i=0; p*p+q*q < 4 && i < 32; i++)) do
							 ((pnew=p*p-q*q+a, q=2*p*q+b, p=pnew))
					 done
					 ((colour=(i/4)%8))
						echo -n "\\e[4${colour}m "
				done
				echo
		done
}
