#!/usr/bin/env bash
set -Eeuo pipefail

# add-focused window to the floating rules in rc.lua
# - inspects focused client (class/instance/name/role)
# - picks a reasonably specific identifier (prefers class, then instance, role, name)
# - appends to the correct list in the floating rule_any block
# - preserves indentation and comments; wraps to a new line when long
# - makes a timestamped backup and archives older backups to ./old/

CONFIG="/home/milk/dotfiles/awesome/.config/awesome/rc.lua"
MARKER="floatingggggggggg"
MAX_LINE_LEN=100

die() { printf 'error: %s\n' "$*" >&2; exit 1; }

ensure_tools() {
  local missing=()
  for t in xprop awk sed; do
    command -v "$t" >/dev/null 2>&1 || missing+=("$t")
  done
  if ((${#missing[@]})); then
    die "missing required tools: ${missing[*]}"
  fi
}

get_active_window_id() {
  local id
  if command -v xdotool >/dev/null 2>&1; then
    id=$(xdotool getactivewindow 2>/dev/null || true)
    if [[ -n "$id" ]]; then printf '%s\n' "$id"; return 0; fi
  fi
  # fallback via xprop
  local hex
  hex=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{print $NF}') || true
  if [[ -n "$hex" && "$hex" =~ ^0x[0-9a-fA-F]+$ ]]; then
    printf '%d\n' "$hex"
    return 0
  fi
  return 1
}

escape_lua_string() {
  # escape backslashes and quotes
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/\"/\\\"/g'
}

backup_config() {
  local ts dst backdir dir
  dir=$(dirname -- "$CONFIG")
  ts=$(date +%Y%m%d-%H%M%S)
  dst="$CONFIG.bak-$ts"
  cp --preserve=mode,timestamps --reflink=auto "$CONFIG" "$dst"
  backdir="$dir/old"
  mkdir -p -- "$backdir"
  # keep latest 3 backups in place, archive older to ./old
  shopt -s nullglob
  local backups=("$CONFIG".bak-*)
  if ((${#backups[@]} > 3)); then
    # sort lexicographically; timestamps are sortable
    local to_move=("${backups[@]:0:${#backups[@]}-3}")
    for f in "${to_move[@]}"; do
      mv -f -- "$f" "$backdir/" || true
    done
  fi
  shopt -u nullglob
}

choose_identifier() {
  # stdout: type|value  where type in {class,instance,role,name}
  local winid="$1"
  local class_line name_line role_line type_line
  class_line=$(xprop -id "$winid" WM_CLASS 2>/dev/null | head -n1 || true)
  name_line=$(xprop -id "$winid" WM_NAME 2>/dev/null | head -n1 || true)
  role_line=$(xprop -id "$winid" WM_WINDOW_ROLE 2>/dev/null | head -n1 || true)
  type_line=$(xprop -id "$winid" _NET_WM_WINDOW_TYPE 2>/dev/null | head -n1 || true)

  local instance class name role
  if [[ "$class_line" =~ WM_CLASS ]]; then
    # WM_CLASS(STRING) = "instance", "Class"
    instance=$(sed -n 's/.*WM_CLASS[^=]*=\s*"\(.*\)",\s*"\(.*\)".*/\1/p' <<<"$class_line")
    class=$(sed -n 's/.*WM_CLASS[^=]*=\s*"\(.*\)",\s*"\(.*\)".*/\2/p' <<<"$class_line")
  fi
  if [[ "$name_line" =~ WM_NAME ]]; then
    # WM_NAME(STRING) = "Name" or WM_NAME(COMPOUND_TEXT) =
    name=$(sed -n 's/.*WM_NAME[^=]*=\s*"\(.*\)".*/\1/p' <<<"$name_line")
  fi
  if [[ "$role_line" =~ WM_WINDOW_ROLE ]]; then
    role=$(sed -n 's/.*WM_WINDOW_ROLE[^=]*=\s*"\(.*\)".*/\1/p' <<<"$role_line")
  fi

  # some classes are too generic — prefer instance/role/name for those
  local -a generic_classes=(
    "Alacritty" "URxvt" "XTerm" "kitty" "st-256color" "foot" "wezterm" "WezTerm"
    "Chromium" "firefox" "Firefox" "Navigator" "Brave-browser" "Google-chrome" "Code"
    "mpv" "Vlc" "vlc" "Thunar" "Dolphin" "Nautilus" "Pcmanfm" "Emacs" "org.gnome.Nautilus"
  )
  is_generic_class=false
  for g in "${generic_classes[@]}"; do
    if [[ "${class:-}" == "$g" ]]; then is_generic_class=true; break; fi
  done

  # prefer class if not generic; else instance; else role; else name
  if [[ -n "${class:-}" && $is_generic_class == false ]]; then
    printf 'class|%s\n' "$class"
    return 0
  fi
  if [[ -n "${instance:-}" ]]; then
    printf 'instance|%s\n' "$instance"
    return 0
  fi
  if [[ -n "${role:-}" ]]; then
    printf 'role|%s\n' "$role"
    return 0
  fi
  if [[ -n "${name:-}" ]]; then
    printf 'name|%s\n' "$name"
    return 0
  fi
  return 1
}

already_present_in_floating() {
  local value="$1"
  # fast check anywhere in rc.lua; avoids dup insertion
  grep -Fq -- "\"$value\"" "$CONFIG"
}

insert_into_list() {
  # args: list_name value
  local list="$1"; shift
  local value="$1"
  local escaped
  escaped=$(escape_lua_string "$value")

  # we operate by reading entire file and rewriting with awk
  awk -v marker="$MARKER" -v list="$list" -v newval="$escaped" -v maxlen="$MAX_LINE_LEN" '
    BEGIN {
      inFloating=0; inTarget=0; inserted=0;
    }
    { lines[NR]=$0 }
    END {
      # find floating marker start
      start=0
      for (i=1; i<=NR; i++) {
        if (index(lines[i], marker)) { start=i; break }
      }
      if (start==0) {
        # print unchanged; no marker found
        for (i=1; i<=NR; i++) print lines[i]
        exit 0
      }
      # locate target list block within floating rule_any
      blockStart=0; blockEnd=0
      for (i=start; i<=NR; i++) {
        if (blockStart==0 && lines[i] ~ list"[ \t]*=[ \t]*\{") { blockStart=i; continue }
        if (blockStart>0 && lines[i] ~ /^[ \t]*\},[ \t]*$/) { blockEnd=i; break }
      }
      if (blockStart==0 || blockEnd==0) {
        for (i=1; i<=NR; i++) print lines[i]
        exit 0
      }
      # identify last entry line (with quotes) before blockEnd
      last=-1; firstEntry=-1; entryIndent=""
      for (i=blockStart+1; i<blockEnd; i++) {
        if (firstEntry<0 && lines[i] ~ /\"/) {
          # capture indentation from first entry line
          match(lines[i], /^[ \t]*/)
          entryIndent=substr(lines[i], RSTART, RLENGTH)
          firstEntry=i
        }
        if (lines[i] ~ /\"/) last=i
      }
      if (last<0) {
        # empty list, insert as the only item
        newLine=entryIndent"\""newval"\""
        # insert before blockEnd
        for (i=1; i<blockEnd; i++) print lines[i]
        print newLine
        for (i=blockEnd; i<=NR; i++) print lines[i]
        exit 0
      }
      # analyze last line for comment and capacity
      ll=lines[last]
      cpos=index(ll, "--")
      pre=ll; post=""
      if (cpos>0) { pre=substr(ll,1,cpos-1); post=substr(ll,cpos) }
      # trim trailing spaces in pre
      sub(/[ \t]+$/, "", pre)
      # compute appended line candidate
      app=pre
      if (app !~ /,\s*$/) app=app ","
      app=app " \"" newval "\""
      if (length(app) <= maxlen && cpos==0) {
        # simple append to same line
        lines[last]=app
        if (post!="") lines[last]=lines[last] post
        inserted=1
      } else {
        # wrap: ensure trailing comma before comment, then insert a new line before blockEnd
        preComma=pre
        if (preComma !~ /,\s*$/) preComma=preComma","; lines[last]=preComma
        if (post!="") lines[last]=lines[last] post
        newLine=entryIndent"\""newval"\""
        # shift tail and insert newLine before blockEnd
        for (i=1; i<blockEnd; i++) print lines[i]
        print newLine
        for (i=blockEnd; i<=NR; i++) print lines[i]
        exit 0
      }
      for (i=1; i<=NR; i++) print lines[i]
    }
  ' "$CONFIG" >"$CONFIG.tmp"

  mv -f -- "$CONFIG.tmp" "$CONFIG"
}

main() {
  ensure_tools
  [[ -f "$CONFIG" ]] || die "rc.lua not found at $CONFIG"
  local winid
  winid=$(get_active_window_id) || die "cannot determine active window id"

  IFS='|' read -r chosen_type chosen_value < <(choose_identifier "$winid") || die "unable to infer identifier from focused window"
  [[ -n "$chosen_value" ]] || die "empty identifier"

  # skip if already present
  if already_present_in_floating "$chosen_value"; then
    # politely bail
    printf 'already present: %s "%s"\n' "$chosen_type" "$chosen_value"
    exit 0
  fi

  backup_config
  insert_into_list "$chosen_type" "$chosen_value"

  # make the current window float immediately (no WM restart)
  if command -v awesome-client >/dev/null 2>&1; then
    printf '%s\n' 'c=client.focus if c then c.floating=true c.ontop=true end' | awesome-client >/dev/null 2>&1 || true
  fi

  # optional desktop notification if available
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "awesomewm" "added $chosen_type=\"$chosen_value\" to floating rules"
  else
    printf 'added %s="%s" to floating rules\n' "$chosen_type" "$chosen_value"
  fi
}

main "$@"



