#!/usr/bin/env bash
set -Eeuo pipefail

# add the focused window to the floating rules in rc.lua
# - inspects focused client (class/instance/name/role)
# - picks a specific identifier (prefers class unless generic, then instance, role, name)
# - appends to the correct list in the floating rule_any block
# - preserves indentation and comments; wraps to a new line when long
# - makes timestamped backups and rotates them per policy
#
# backup policy:
# - filename: rc.lua.bak-YYYYMMDD_ hhmm (24h)
# - keep last 5 in place
# - older than latest 5 go to ./old
# - >1 day -> old/week/
# - >1 week -> old/month/
# - >1 month -> old/year/

CONFIG="$HOME/.config/awesome/rc.lua"
MARKER="floatingggggggggg"
MAX_LINE_LEN=100

_die() { printf 'error: %s\n' "$*" >&2; exit 1; }

_need() {
  local missing=()
  for t in xprop awk sed date grep mv mkdir find stat touch; do
    command -v "$t" >/dev/null 2>&1 || missing+=("$t")
  done
  if ((${#missing[@]})); then _die "missing required tools: ${missing[*]}"; fi
}

_get_active_window_id() {
  local id
  if command -v xdotool >/dev/null 2>&1; then
    id=$(xdotool getactivewindow 2>/dev/null || true)
    if [[ -n "$id" ]]; then printf '%s\n' "$id"; return 0; fi
  fi
  local hex
  hex=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{print $NF}') || true
  if [[ -n "$hex" && "$hex" =~ ^0x[0-9a-fA-F]+$ ]]; then
    printf '%d\n' "$hex"
    return 0
  fi
  return 1
}

_escape_lua() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/\"/\\\"/g'
}

_backup_rotate() {
  local dir ts dst backdir now secs_day secs_week secs_month f mtime age
  dir=$(dirname -- "$CONFIG")
  ts=$(date +%Y%m%d_%H%M)
  dst="$CONFIG.bak-$ts"
  cp --preserve=mode,timestamps --reflink=auto "$CONFIG" "$dst"

  backdir="$dir/old"
  mkdir -p -- "$backdir" "$backdir/week" "$backdir/month" "$backdir/year"

  # keep latest 5 in-place, move the rest to ./old
  shopt -s nullglob
  local backups=("$CONFIG".bak-*)
  if ((${#backups[@]} > 5)); then
    # sort lexicographically
    IFS=$'\n' backups=($(printf '%s\n' "${backups[@]}" | sort))
    local to_move=("${backups[@]:0:${#backups[@]}-5}")
    for f in "${to_move[@]}"; do mv -f -- "$f" "$backdir/" || true; done
  fi
  shopt -u nullglob

  # age buckets for files already under ./old
  now=$(date +%s)
  secs_day=$((24*60*60))
  secs_week=$((7*24*60*60))
  secs_month=$((30*24*60*60))

  find "$backdir" -maxdepth 1 -type f -name 'rc.lua.bak-*' -print0 | while IFS= read -r -d '' f; do
    mtime=$(stat -c %Y -- "$f") || continue
    age=$((now - mtime))
    if (( age > secs_month )); then
      mv -f -- "$f" "$backdir/year/" || true
    elif (( age > secs_week )); then
      mv -f -- "$f" "$backdir/month/" || true
    elif (( age > secs_day )); then
      mv -f -- "$f" "$backdir/week/" || true
    fi
  done
}

_choose_identifier() {
  local winid="$1"
  local class_line name_line role_line instance class name role
  class_line=$(xprop -id "$winid" WM_CLASS 2>/dev/null | head -n1 || true)
  name_line=$(xprop -id "$winid" WM_NAME 2>/dev/null | head -n1 || true)
  role_line=$(xprop -id "$winid" WM_WINDOW_ROLE 2>/dev/null | head -n1 || true)

  if [[ "$class_line" =~ WM_CLASS ]]; then
    instance=$(sed -n 's/.*WM_CLASS[^=]*=\s*"\(.*\)",\s*"\(.*\)".*/\1/p' <<<"$class_line")
    class=$(sed -n 's/.*WM_CLASS[^=]*=\s*"\(.*\)",\s*"\(.*\)".*/\2/p' <<<"$class_line")
  fi
  if [[ "$name_line" =~ WM_NAME ]]; then
    name=$(sed -n 's/.*WM_NAME[^=]*=\s*"\(.*\)".*/\1/p' <<<"$name_line")
  fi
  if [[ "$role_line" =~ WM_WINDOW_ROLE ]]; then
    role=$(sed -n 's/.*WM_WINDOW_ROLE[^=]*=\s*"\(.*\)".*/\1/p' <<<"$role_line")
  fi

  local -a generic_classes=(
    "Alacritty" "URxvt" "XTerm" "kitty" "st-256color" "foot" "wezterm" "WezTerm"
    "Chromium" "firefox" "Firefox" "Navigator" "Brave-browser" "Google-chrome" "Code"
    "mpv" "Vlc" "vlc" "Thunar" "Dolphin" "Nautilus" "Pcmanfm" "Emacs" "org.gnome.Nautilus"
  )
  local is_generic=false g
  for g in "${generic_classes[@]}"; do
    if [[ "${class:-}" == "$g" ]]; then is_generic=true; break; fi
  done

  if [[ -n "${class:-}" && $is_generic == false ]]; then printf 'class|%s\n' "$class"; return 0; fi
  if [[ -n "${instance:-}" ]]; then printf 'instance|%s\n' "$instance"; return 0; fi
  if [[ -n "${role:-}" ]]; then printf 'role|%s\n' "$role"; return 0; fi
  if [[ -n "${name:-}" ]]; then printf 'name|%s\n' "$name"; return 0; fi
  return 1
}

_already_present() {
  local value="$1"
  grep -Fq -- "\"$value\"" "$CONFIG"
}

_insert_into_list() {
  local list="$1"; shift
  local value="$1"
  local escaped
  escaped=$(_escape_lua "$value")
  awk -v marker="$MARKER" -v list="$list" -v newval="$escaped" -v maxlen="$MAX_LINE_LEN" '
    BEGIN { }
    { lines[NR]=$0 }
    END {
      start=0
      for (i=1; i<=NR; i++) if (index(lines[i], marker)) { start=i; break }
      if (start==0) { for (i=1; i<=NR; i++) print lines[i]; exit 0 }
      blockStart=0; blockEnd=0
      for (i=start; i<=NR; i++) {
        if (blockStart==0 && lines[i] ~ list"[ \t]*=[ \t]*\{") { blockStart=i; continue }
        if (blockStart>0 && lines[i] ~ /^[ \t]*\},[ \t]*$/) { blockEnd=i; break }
      }
      if (blockStart==0 || blockEnd==0) { for (i=1; i<=NR; i++) print lines[i]; exit 0 }
      last=-1; firstEntry=-1; entryIndent=""
      for (i=blockStart+1; i<blockEnd; i++) {
        if (firstEntry<0 && lines[i] ~ /\"/) { match(lines[i], /^[ \t]*/); entryIndent=substr(lines[i], RSTART, RLENGTH); firstEntry=i }
        if (lines[i] ~ /\"/) last=i
      }
      if (last<0) {
        newLine=entryIndent"\""newval"\""
        for (i=1; i<blockEnd; i++) print lines[i]
        print newLine
        for (i=blockEnd; i<=NR; i++) print lines[i]
        exit 0
      }
      ll=lines[last]
      cpos=index(ll, "--")
      pre=ll; post=""
      if (cpos>0) { pre=substr(ll,1,cpos-1); post=substr(ll,cpos) }
      sub(/[ \t]+$/, "", pre)
      app=pre
      if (app !~ /,\s*$/) app=app ","
      app=app " \"" newval "\""
      if (length(app) <= maxlen && cpos==0) {
        lines[last]=app
        if (post!="") lines[last]=lines[last] post
      } else {
        preComma=pre
        if (preComma !~ /,\s*$/) preComma=preComma","; lines[last]=preComma
        if (post!="") lines[last]=lines[last] post
        newLine=entryIndent"\""newval"\""
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

_main() {
  _need
  [[ -f "$CONFIG" ]] || _die "rc.lua not found at $CONFIG"
  local winid
  winid=$(_get_active_window_id) || _die "cannot determine active window id"

  IFS='|' read -r chosen_type chosen_value < <(_choose_identifier "$winid") || _die "unable to infer identifier from focused window"
  [[ -n "$chosen_value" ]] || _die "empty identifier"

  if _already_present "$chosen_value"; then
    printf 'already present: %s "%s"\n' "$chosen_type" "$chosen_value"
    exit 0
  fi

  _backup_rotate
  _insert_into_list "$chosen_type" "$chosen_value"

  if command -v awesome-client >/dev/null 2>&1; then
    printf '%s\n' 'c=client.focus if c then c.floating=true c.ontop=true end' | awesome-client >/dev/null 2>&1 || true
  fi

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "awesomewm" "added $chosen_type=\"$chosen_value\" to floating rules"
  else
    printf 'added %s="%s" to floating rules\n' "$chosen_type" "$chosen_value"
  fi
}

_main "$@"
