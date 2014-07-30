# prompt.zsh: A custom prompt for zsh (256 color version).
# P.C. Shyamshankar <sykora@lucentbeing.com>

local p="%{$FX[reset]$FG[255]%}"

local name="%{$FX[reset]$FG[117]%}%n"
local host="%{$FX[reset]$FG[177]%}%m"
local jobs="%1(j.(%{$FX[reset]$FG[197]%}%j job%2(j.s.)${p})-.)"
local time="%{$FX[reset]$FG[180]%}%D{%H:%M}"
local dir="%{$FX[reset]$FG[199]%}%~"

local last="%(?..%{$FX[reset]$FG[203]%}%??${p}:)"
local hist="%{$FX[reset]$FG[220]%}%!!"
local priv="%{$FX[reset]$FG[245]%}%#"

git_branch=""

# PROMPT="${name}${p}@${host}${p}${jobs}${p}:${dir}${p}\${git_branch}${p} %(!.#.$) "
PROMPT="${time}${p} ${name}${p}@${host}${p}${jobs}${p}:${dir}${p}\$(git_super_status)${p} %(!.#.$) "
# RPS1=""

#PROMPT="${p}(${name}${p}@${host}${p})-${jobs}(${time}${p})-(${dir}${p}\${git_branch}${p})
#(${last}${p}${hist}${p}:${priv}${p})- %{$FX[reset]%}"

#PS1="%(#~$PR_RED~$PR_CYAN)%n$PR_WHITE@$PR_MAGENTA%m$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR %(!.#.$)$b % "
#RPS1="$PR_YELLOW(%D{%H:%M})$PR_NO_COLOR"
