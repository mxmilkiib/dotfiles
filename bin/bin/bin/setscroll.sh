#!/bin/bash
# https://unix.stackexchange.com/questions/116216/start-scrolling-command-prompt-when-filled-until-a-particular-fraction
function min(){
  if [[ $1 -le $2 ]]; then echo $1; else echo $2; fi
}

function max(){
  if [[ $1 -ge $2 ]]; then echo $1; else echo $2; fi
}

function setscrollregion(){
  CLR="\033[2J"
  SRGN="\033[1;"$1"r"
  echo -ne $CLR$SRGN
}

function calcline(){

  set `stty size` $1            # ;echo height=$1 width=$2 perc=$3
  bline=$(( ($1 * $3 ) / 100  ))    # calculate bottom line
  bline=$( min $bline $1)       # max is screen height
  bline=$( max 5 $bline)        # min is 5 lines customise as you wish
  echo $bline
}

setscrollregion $(calcline $1)
