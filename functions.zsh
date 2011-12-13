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
    *xterm*|*rxvt*)
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

	echo -e "$(pacman -Ss "$@" | sed "
		/^core/		s,.*,${CL}1;31m&${RS},
		/^extra/	s,.*,${CL}0;32m&${RS},
		/^community/	s,.*,${CL}1;35m&${RS},
		/^[^[:space:]]/	s,.*,${CL}0;36m&${RS},
	")"
}

# Easy Aurget
function aurge(){
  aurget -Sy "$@" --deps --noedit --discard;
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
