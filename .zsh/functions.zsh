# functions.zsh: Custom functions, and function invocations.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# http://lucentbeing.com/writing/archives/a-guide-to-256-color-codes/
if (( C == 256 )); then
    autoload spectrum && spectrum # Set up 256 color support.
fi

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


# Follow copied and moved files to destination directory
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }

# go to new directory
function md() { mkdir -p "$1" && cd "$1"; }

# cd and ls -la
cl() { cd "$1" && lt . ; }


# Search in files
function gcode() { grep --color=always -rnC3 -- "$@" . | /usr/bin/less -R; }

# Browse path web browser like
function up() { pushd .. > /dev/null; }
function down() { popd > /dev/null; }

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

# Easy Aurget
function aurge(){
  local pretmp=$PWD
  cd /tmp/
  aurget -Sy "$@" --deps --noedit;
  cd $pretmp
}

# Easy Git commit
function gc(){
  git commit -m "$*";
}


# Check if command exists
command_exists () {
    type "$1" &> /dev/null ;
}

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



function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    zle reset-prompt
}

zle -N zle-keymap-select

# IRC like buffer new lines
# works on arch anyway....
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

function headless(){
  VBoxHeadless -startvm "$@" &
}

# Disk usage

# function duf {
#   du -sk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
# }

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

# Link to Dropbox
drbox() {
  ln -s "$*" ~/Dropbox
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

