# options.zsh: Set Z-Shell options.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# http://linux.die.net/man/1/zshoptions

# Directory Changing options
setopt AUTO_CD                      # Automatically cd in to directories if it's not a command name.
setopt AUTO_PUSHD                   # Automatically push visited directories to the stack.
setopt PUSHD_IGNORE_DUPS            # ...and don't duplicate them.

# History Options
setopt APPEND_HISTORY               # Don't overwrite history.
setopt INC_APPEND_HISTORY						# Add entries to history directly instead of at shell exit
setopt SHARE_HISTORY								# Share history file between zsh shell instances
setopt HIST_VERIFY                  # Verify commands that use a history expansion.
setopt HIST_IGNORE_SPACE            # Ignore commands with leading spaces.
setopt HIST_IGNORE_ALL_DUPS         # Ignore all duplicate entries in the history.
setopt HIST_REDUCE_BLANKS           # Tidy up commands before comitting them to history.
setopt EXTENDED_HISTORY             # Remember all sorts of stuff about the history.

# setopt RM_STAR_WAIT                 # Wait, and ask if the user is serious when doing rm *

setopt EXTENDED_GLOB                # Give meaning to lots of crazy characters.

# Completion Options
setopt AUTO_LIST                    # Always automatically show a list of ambiguous completions.
setopt COMPLETE_IN_WORD             # Complete items from the beginning to the cursor.
# setopt NO_ALWAYS_LAST_PROMPT	      # Put prompt beneath potentials
setopt COMPLETEALIASES		    			# Complete aliased commands
setopt MENU_COMPLETE								# First tab selects first option

setopt NO_BEEP                      # Never, ever, beep at me.

setopt LOCAL_OPTIONS                # Options set/unset inside functions, stay within the function.
setopt INTERACTIVE_COMMENTS         # Allow me to comment lines in an interactive shell.

setopt MULTIBYTE
unsetopt FLOW_CONTROL

# Correction
# setopt CORRECT											# spelling correction for commands
# setopt CORRECTALL										# spelling correction for arguments


# Prompt settings
setopt PROMPT_SUBST                 # Expand parameters within prompts.

autoload -U promptinit
promptinit

# Colour support
# autoload -U colors && colors			# set in git-prompt
