# functions.zsh: Custom functions, and function invocations.
# P.C. Shyamshankar <sykora@lucentbeing.com>

if (( C == 256 )); then
    autoload spectrum && spectrum # Set up 256 color support.
fi

# Simple function to get the current git branch.
function git_current_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    print "${ref#refs/heads/}"
}

case $TERM in
    *xterm*|*rxvt*|*screen*)
        # Special function precmd, executed before displaying each prompt.
        function precmd() {
            # Set the terminal title to the current working directory.
            print -Pn "\e]0;%~: %n@%m\a"

            # Get the current git branch into the prompt.
            git_branch=""
            current_branch=$(git_current_branch)

            if [[ ${current_branch} != "" ]]; then
                if (( C == 256 )); then
                    git_status=$(git status --porcelain)
                    if [[ $git_status == "" ]]; then
                        branch_color=222
                    elif (( $(echo $git_status | grep -c "^.M\|??") > 0 )); then
                        branch_color=160
                    else
                        branch_color=082
                    fi

                    git_branch=":%{$FX[reset]$FG[${branch_color}]%}${current_branch}"
                else
                    git_branch=":${current_branch}"
                fi
            fi
        }

        # Special function preexec, executed before running each command.
        function preexec () {
            # Set the terminal title to the currently executing command.
            command=$(print -P "%60>...>$1")
            print -Pn "\e]0;$command (%~) : %n@%m\a"
        }
esac

# Autoload some useful utilities.
autoload -Uz zmv
autoload -Uz zargs

# Pronounciation
say() { mplayer "http://translate.google.com/translate_tts?q=$1"; }

# Browse path web browser like
function up() { pushd .. > /dev/null; }
function down() { popd > /dev/null; }

# Search in files
function gcode() { grep --color=always -rnC3 -- "$@" . | less -R; }

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

# get_iplayer radio
function gr() { get_iplayer -g --modes=flashaacstd --pid=$1; }

pS() {
	local CL='\\e['
	local RS='\\e[0;0m'

	echo -e "$(packer -Ss "$@" | sed "
		/^core/		s,.*,${CL}1;31m&${RS},
		/^extra/	s,.*,${CL}0;32m&${RS},
		/^community/	s,.*,${CL}1;35m&${RS},
		/^[^[:space:]]/	s,.*,${CL}0;36m&${RS},
	  ")"
}

# Easy Aurget
function aurge(){
  local pretmp=$PWD
  cd /var/tmp/pkg
  aurget -Sy "$@" --deps --noedit;
  cd $pretmp
}

# Easy Git commit
function gitc(){
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

# Extract Files
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
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "\`$1': unrecognized file compression" ;;
      esac
  else
      echo "\`$1' is not a valid file"
  fi
}

# Follow copied and moved files to destination directory
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }
goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }

# cd and ls -la
cl() { cd "$1" && ls -lah . ; }


function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/ M:command}/(main|viins)/}"
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
