# zsh configuration assessment

**STATUS: COMPLETED 2025-10-03**

see `CHANGES.md` for detailed implementation notes.

## current state (original issues - now fixed)

### keymap mode confusion
- **line 269** (`.zshrc`): sets `bindkey -e` (emacs mode)
- **line 268** (`.zshrc`): `zle-line-init()` forces `viins` mode on each line init
- **result**: system is in a hybrid state - starts in vi insert mode but has emacs base bindings

### terminfo handling issues

#### positive aspects
- lines 10-26 (`bindings.zsh`): properly builds `$key` array from `$terminfo`
- lines 149-152: handles ncurses application mode quirk (`\eO` → `\e[`)
- lines 257-266: enables application mode with `smkx`/`rmkx`

#### problems identified
1. **hardcoded fallbacks override terminfo** (lines 34-42)
   - sets multiple hardcoded escape sequences after terminfo check
   - defeats purpose of terminfo-based binding
   
2. **duplicate bindings scattered throughout**
   - home/end bound at lines 34-41, 272-282
   - ctrl-left/right bound at lines 63-74 (multiple variants)
   - alt-left/right bound at lines 80-84
   
3. **commented terminfo code** (lines 226-252)
   - large block of proper terminfo handling commented out
   - includes both emacs and vicmd mode handling
   - appears more comprehensive than current active code

4. **missing terminfo keys**
   - `key[CtrlLeft]` and `key[CtrlRight]` use non-standard terminfo entries
   - `kLFT5` and `kRFT5` not universally supported
   - should use standard entries or handle missing values

### help message inaccuracies

**current message** (`.zshrc` lines 12-15):
```
c-b  Back one character       c-f  Forward a character      c-h  Delete back a character  c-d  Delete a character
a-b  Back to word end         a-f  Forward to word end      c-w  Delete back a word       a-d  Delete forward a word
c-p  Up one line              c-n  Down one line            c-k  Delete to end of line    c-u  Delete entire line
c-a  Go to line start         c-e  Jump to line end
```

**actual bindings** (from `bindings.zsh`):
- `c-b`: bound to `backward-word` (line 86), not backward-char
- `c-f`: bound to `forward-word` (line 87), not forward-char
- `c-h`: bound to `backward-kill-word` (lines 92-93), not backward-delete-char
- `c-d`: bound to `kill-word` (line 101), not delete-char
- `c-w`: not bound (would default to `backward-kill-word` in emacs mode)
- `a-b`, `a-f`, `a-d`: not explicitly bound
- `c-p`, `c-n`: not explicitly bound (would use emacs defaults)
- `c-k`: correctly bound to `kill-line` (line 191)
- `c-u`: correctly bound to `kill-whole-line` (line 194)
- `c-a`, `c-e`: correctly bound (lines 36-37)

### binding conflicts and redundancy

#### overlapping functionality
1. **two sudo prependers**:
   - `F2`: `prepend-sudo` (line 166)
   - `alt-s`: `insert-sudo` (line 223)
   
2. **history search duplication**:
   - up/down: `history-substring-search` (lines 49-50, 131-132)
   - ctrl-up/down: `history-beginning-search` (lines 126-127)
   
3. **word movement chaos**:
   - ctrl-left/right: `emacs-backward-word`/`emacs-forward-word` (multiple bindings)
   - alt-left/right: `backward-word`/`forward-word`
   - multiple escape sequences for same function

#### broken/questionable bindings
- line 43: insert marked as "broken?"
- line 175: `F5` bound to string `"bat *"` instead of widget
- line 1: comment "two thirds through fixing" suggests incomplete work

### vim mode integration

**current setup** (`.zshrc` lines 259-272):
- cursor color changes: cyan in vicmd, default in viins
- `zle-line-init` forces viins mode
- no explicit ESC binding visible

**missing elements**:
- no `bindkey -v` anywhere (would conflict with `bindkey -e`)
- relies on `zle-line-init` forcing viins, which is fragile
- commented-out comprehensive vim setup (lines 187-229 in `.zshrc`)

## recommendations

### 1. clarify keymap strategy

**option a: hybrid mode (recommended for your use case)**
- keep `bindkey -e` as base
- add explicit `bindkey '^[' vi-cmd-mode` to enter vim command mode with ESC
- preserve current emacs bindings for normal use
- enables vim motions after ESC while keeping readline muscle memory

**option b: pure vi mode**
- replace `bindkey -e` with `bindkey -v`
- remove conflicting emacs bindings
- requires relearning all navigation

### 2. fix terminfo handling

**create terminfo-aware binding function**:
```zsh
# bind key with terminfo fallbacks
bind_key_safe() {
  local keyname=$1
  local widget=$2
  local mode=${3:-emacs}
  
  if [[ -n "${key[$keyname]}" ]]; then
    bindkey -M $mode "${key[$keyname]}" $widget
  fi
}
```

**use consistent pattern**:
- check terminfo first
- only add hardcoded fallbacks for truly universal sequences
- bind for each mode explicitly if using hybrid setup

### 3. fix help message

**approach**: generate from actual bindings
```zsh
# after sourcing bindings.zsh
declare -A help_bindings
help_bindings=(
  "c-a" "$(bindkey | grep '\^A' | awk '{print $2}')"
  "c-e" "$(bindkey | grep '\^E' | awk '{print $2}')"
  # ... etc
)
```

**or**: hardcode correctly to match actual bindings in `bindings.zsh`

### 4. reorganize bindings.zsh

**proposed structure**:
```
# section 1: terminfo setup
# - key array population
# - application mode hooks

# section 2: core navigation (terminfo-based)
# - home/end
# - arrows
# - page up/down
# - word movement

# section 3: editing operations
# - deletion
# - insertion
# - history

# section 4: special functions
# - F-keys
# - custom widgets

# section 5: mode-specific overrides
# - vicmd bindings
# - viins bindings
```

### 5. handle missing terminfo gracefully

```zsh
# example for ctrl-left/right
key[CtrlLeft]=${terminfo[kLFT5]:-'^[[1;5D'}  # fallback for xterm
key[CtrlRight]=${terminfo[kRFT5]:-'^[[1;5C'}

# or detect terminal and set accordingly
case $TERM in
  xterm*|*-256color)
    key[CtrlLeft]='^[[1;5D'
    key[CtrlRight]='^[[1;5C'
    ;;
  rxvt*|urxvt*)
    key[CtrlLeft]='\eOd'
    key[CtrlRight]='\eOc'
    ;;
esac
```

## specific fixes needed

### high priority
1. **decide on keymap mode**: hybrid (emacs + vim after ESC) or pure vim
2. **fix help message**: match actual bindings or generate dynamically
3. **deduplicate home/end bindings**: remove hardcoded duplicates
4. **remove broken F5 binding**: line 175

### medium priority
1. **consolidate word movement**: pick one modifier (ctrl vs alt) per direction
2. **document terminfo requirements**: what terminals are supported
3. **add missing mode bindings**: if using hybrid, ensure vim mode works properly
4. **uncomment and adapt**: lines 226-252 if they're better than current setup

### low priority
1. **decide on sudo binding**: F2 vs alt-s, remove redundant one
2. **clean up commented code**: remove if not needed, implement if useful
3. **add binding documentation**: inline comments for non-obvious choices

## testing approach

1. **terminfo verification**:
   ```zsh
   # run in fresh shell
   zmodload zsh/terminfo
   echo $TERM
   print -l ${(k)terminfo} | grep -E 'k(home|end|.*[0-9])'
   ```

2. **binding verification**:
   ```zsh
   bindkey | grep -E '\^(A|E|B|F|H|D|K|U)'  # check ctrl bindings
   bindkey | grep -E '\^\[' # check alt/meta bindings
   ```

3. **mode verification**:
   ```zsh
   bindkey -l  # list keymaps
   bindkey -M main  # show main keymap bindings
   ```

## implementation order

if you approve, I recommend:

1. create backup: `cp bindings.zsh bindings.zsh.$(date +%Y%m%d_%H%M).bak`
2. fix help message (immediate visual feedback)
3. clarify keymap mode (affects all other changes)
4. reorganize bindings with proper terminfo checks
5. test in clean shell
6. iterate based on actual terminal behavior
