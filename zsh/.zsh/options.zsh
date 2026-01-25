# options.zsh: Set Z-Shell options.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# http://linux.die.net/man/1/zshoptions

# directory navigation
setopt AUTO_CD               # automatically cd into directories if the name is not a command
setopt AUTO_PUSHD            # automatically push visited directories onto the stack
setopt PUSHD_IGNORE_DUPS     # avoid duplicate entries when pushing directories

# history
setopt APPEND_HISTORY        # append to the history file instead of overwriting it
setopt INC_APPEND_HISTORY    # add history entries immediately instead of at shell exit
setopt SHARE_HISTORY         # share history between interactive shells
setopt HIST_VERIFY           # confirm commands that expand history
setopt HIST_IGNORE_SPACE     # ignore commands with a leading space
setopt HIST_IGNORE_ALL_DUPS  # keep only the most recent duplicate command
setopt HIST_FIND_NO_DUPS     # skip duplicates when navigating history search results
setopt HIST_REDUCE_BLANKS    # strip superfluous whitespace before saving a command
setopt EXTENDED_HISTORY      # store timestamp and duration with each history entry

# globbing
setopt EXTENDED_GLOB         # enable extended glob patterns
setopt NUMERIC_GLOB_SORT     # sort glob matches numerically (1, 2, 10)

# completion
setopt AUTO_LIST             # automatically show ambiguous completions
setopt COMPLETE_IN_WORD      # allow completion from the cursor position
# setopt NO_ALWAYS_LAST_PROMPT # place the prompt after completion lists
setopt COMPLETE_ALIASES      # expand completions for aliases
setopt MENU_COMPLETE         # select the first completion on the initial tab press
setopt GLOB_DOTS             # include dotfiles when globbing
setopt AUTO_PARAM_SLASH      # append a trailing slash when completing directories

# interaction
setopt NO_BEEP               # disable the terminal bell
setopt LOCAL_OPTIONS         # confine option changes within functions
setopt INTERACTIVE_COMMENTS  # allow comments in interactive code
setopt MULTIBYTE             # enable multibyte character support
unsetopt FLOW_CONTROL        # free ctrl-s/ctrl-q for regular use

# correction
# setopt CORRECT             # spell-check commands before execution
# setopt CORRECTALL          # spell-check command arguments

# prompt
setopt PROMPT_SUBST          # expand parameters within prompts

autoload -U promptinit
promptinit

# colour support
# autoload -U colors && colors  # set in git-prompt

# https://github.com/zsh-users/zsh/blob/master/Functions/Zle/bracketed-paste-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
# zstyle :bracketed-paste-magic paste-init backward-extend-paste