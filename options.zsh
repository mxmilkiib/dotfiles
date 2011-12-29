# options.zsh: Set Z-Shell options.
# P.C. Shyamshankar <sykora@lucentbeing.com>

# Directory Changing options
setopt AUTO_CD                      # Automatically cd in to directories if it's not a command name.
setopt AUTO_PUSHD                   # Automatically push visited directories to the stack.
setopt PUSHD_IGNORE_DUPS            # ...and don't duplicate them.

# History Options
setopt APPEND_HISTORY               # Don't overwrite history.

# With this option all history items remain in chronological order even when multiple ZSH instance are open at the same time. This is achieved by writing entries directly into the file instead of dumping the whole history when the shell exits. http://www.refining-linux.org/archives/49/ZSH-Gem-15-Shared-history/

# setopt INC_APPEND_HISTORY

# write history entries directly to the history file, share the current history file between all sessions.

setopt SHARE_HISTORY


setopt HIST_VERIFY                  # Verify commands that use a history expansion.
setopt EXTENDED_HISTORY             # Remember all sorts of stuff about the history.
setopt HIST_IGNORE_SPACE            # Ignore commands with leading spaces.
setopt HIST_IGNORE_ALL_DUPS         # Ignore all duplicate entries in the history.
setopt HIST_REDUCE_BLANKS           # Tidy up commands before comitting them to history.

setopt RM_STAR_WAIT                 # Wait, and ask if the user is serious when doing rm *

setopt EXTENDED_GLOB                # Give meaning to lots of crazy characters.

# Completion Options
setopt AUTO_LIST                    # Always automatically show a list of ambiguous completions.
setopt COMPLETE_IN_WORD             # Complete items from the beginning to the cursor.
setopt NO_ALWAYS_LAST_PROMPT	    # Put prompt beneath potentials
setopt COMPLETEALIASES		    # Complete aliased commands

setopt NO_BEEP                      # Never, ever, beep at me.

setopt PROMPT_SUBST                 # Expand parameters within prompts.

setopt LOCAL_OPTIONS                # Options set/unset inside functions, stay within the function.
setopt INTERACTIVE_COMMENTS         # Allow me to comment lines in an interactive shell.

setopt MULTIBYTE
unsetopt FLOW_CONTROL

# Prompt settings
autoload -U promptinit
promptinit

# Colour support
autoload -U colors && colors
