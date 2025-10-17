# License at bottom

[[ $- == *i* ]] || return 0

basta_old_cmdno=${basta_old_cmdno-0}
basta_old_lines=${basta_old_lines-0}
basta_old_cols=${basta_old_cols-0}
basta_last_check_epoch=${basta_last_check_epoch-0}

basta_scroll_lines=${basta_scroll_lines-0}
basta_prev_reserved_rows=${basta_prev_reserved_rows-}

basta_status_alarm_pid=${basta_status_alarm_pid-}
basta_executing=y
basta_deferred_intr=${basta_deferred_intr-}

basta.query_terminal_lines()
{
  local intovar=$1
  local result
  printf $'\e7\e[999;999H'
  basta.get_cur_line $intovar
  result=$?
  printf $'\e8'
  return $result
}

basta.query_termios_lines_cols()
{
  local -n linesvar=$1
  local -n colsvar=$2
  local pair=$(stty size)
  set -- $pair
  linesvar=$1
  colsvar=$2
}

basta.ensure_bottom_margin()
{
  local i
  local realrows=$1

  printf $'\e7\e[1;%sr\e8' $realrows
  for (( i = 0; i <= basta_prev_reserved_rows; i++ )); do
    printf $'\n'
  done
  printf $'\e[%sA' $i
}

basta.prepare_term()
{
  local realrows
  local i

  if ! basta.query_terminal_lines realrows; then
    return 1
  fi

  if [ -z "$basta_prev_reserved_rows" ] ; then
    basta_prev_reserved_rows=${#LC_basta_status[@]}
    basta.ensure_bottom_margin $realrows
  fi

  LINES=$((realrows - $basta_prev_reserved_rows - 1))

  basta_scroll_lines=$LINES
  basta_old_lines=$LINES
  basta_old_cols=$COLUMNS
  stty rows $LINES
}

basta.get_cur_line()
{
  local -n intovar=$1
  local response=$LINES
  printf '\e[6n' > /dev/tty
  read -t 3 -s -d R response < /dev/tty
  local IFS="[;"
  set -- $response
  [[ "$2" =~ ^[0-9]+$ ]] && intovar=$2
}

if [ $EPOCHSECONDS ] ; then
  basta.epoch()
  {
    local -n intovar=$1
    intovar=$EPOCHSECONDS
  }
else
  basta.epoch()
  {
    local -n intovar=$1
    intovar=$(date +%s)
  }
fi

basta.update_status()
{
  local pwd=$PWD
  local dots=
  local tio_lines
  local tio_cols
  local i j

  basta.query_termios_lines_cols tio_lines tio_cols

  [ "$1" != WINCH -a \
    $LINES -eq $basta_old_lines -a \
    $COLUMNS -eq $basta_old_cols -a \
    $LINES -eq $tio_lines -a \
    $COLUMNS -eq $tio_cols ] || basta.prepare_term

  local status_esc=$'\e[7m\e[m'
  local status_date=$(date +%m-%d/%H:%M)

  while true; do
    local status=$'\e[7m'$CURRENT$'\e[m '" $dots"
    local status_len=$((${#status} - ${#status_esc}))
    [ $status_len -le $COLUMNS ] && break
    [ "${pwd#/*/}" == "$pwd" ] && break
    pwd=${pwd#/}
    pwd=/${pwd#*/}
    dots='...'
  done

  status_len=$((${#status} - ${#status_esc}))

  [ $status_len -gt $COLUMNS ] && status=

  printf $'\e7\e[%s;1H\e[K%s\e[1;%sr' \
         $((basta_scroll_lines + 1)) "$status" $basta_scroll_lines

  for (( i = $basta_prev_reserved_rows - 1, j = 2; i >= 0; i--, j++ )) ; do
    printf $'\e[%s;1H\e[K%s' \
           $((basta_scroll_lines + j)) "${LC_basta_status[i]}"
  done

  printf $'\e8'

  LC_basta_status[$basta_prev_reserved_rows]=$status
  basta.export_array LC_basta_status
}

basta.check_cursor()
{
  if ! read -t 0; then
    local now
    basta.epoch now

    if [ $((now - 3)) -ge $basta_last_check_epoch ] ||
       [ $basta_deferred_intr ]
    then
      local exit=$?
      local curln
      local realrows

      if basta.get_cur_line curln && [ $curln -gt $basta_scroll_lines ]; then
        printf $'\e[%s;1H' $basta_scroll_lines
      fi

      basta_last_check_epoch=$now

      basta.query_terminal_lines realrows &&
      [ $LINES -eq $((realrows - $basta_prev_reserved_rows - 1)) ]
      return $?
    fi
  fi

  return 0
}

basta.do_exit_status()
{
  local exit=$1
  local getcmdno='\#'
  local cmdno=${getcmdno@P}

  if [ $exit -ne 0 -a $cmdno -ne $basta_old_cmdno ] ; then
    printf "!%s!\n" $exit
  fi

  basta_old_cmdno=$cmdno
}

basta.initial_prompt_hook()
{
  local exit=$?
  local basta_executing=y
  stty raw -echo onlcr opost
  basta.update_status
  stty sane
  PROMPT_COMMAND='basta.prompt_hook'
}

basta.prompt_hook()
{
  local exit=$?
  local winch=$basta_deferred_intr

  local basta_executing=y
  stty raw -echo onlcr opost
  basta.check_cursor || winch=WINCH
  basta_deferred_intr=
  basta.update_status $winch
  basta.do_exit_status $exit
  stty sane
}

basta.alarm_timer()
{
  exec 0>&- 1>&- 2>&-
  trap : INT
  while
    sleep 15
    kill -ALRM $$
  do
    :
  done
}

basta.interrupt()
{
  if ! [ $basta_executing ] ; then
    local basta_executing=y
    basta.update_status "$@"
  else
    basta_deferred_intr=$1
  fi
}

basta.install_hooks()
{
  trap 'basta.interrupt ALRM "$_"' ALRM
  trap 'basta.interrupt WINCH "$_"' WINCH
  trap basta.cleanup EXIT
  PROMPT_COMMAND='basta.initial_prompt_hook'
}

basta.remove_hooks()
{
  trap "" ALRM WINCH
  unset PROMPT_COMMAND
}

basta.cleanup()
{
  local newlines=$((LINES + 1))

  printf $'\e7'
  printf $'\e[%s;1H\e[K' $newlines

  if [ $basta_prev_reserved_rows ] &&
     [ $basta_prev_reserved_rows -gt 0 ]
  then
    printf $'\e[1;%sr' $newlines
  else
    printf $'\e[1r'
  fi

  printf $'\e8'
  stty rows $newlines
  kill -KILL $basta_status_alarm_pid
  basta.remove_hooks

  unset LC_basta_status[basta_prev_reserved_rows]
  basta.export_array LC_basta_status

  printf "Basta!\n"
}

basta.export_array()
{
  local name=$1
  local -n a=$name
  local i

  for ((i = 0; i < "${#a[@]}"; i++)); do
     eval export ${name}_$i=\${a[i]}
  done

  for ((; ; i++)); do
     eval [ \"\${${name}_$i+x}\" != x ] && break
     eval unset ${name}_$i
  done
}

basta.import_array()
{
  local name=$1
  local -n a=$name
  local i

  a=()

  for ((i = 0; ; i++)); do
     eval [ \"\${${name}_$i+x}\" != x ] && break
     eval a[$i]=\$${name}_$i
  done
}

# Public API functions

basta.fullscreen()
{
  if [ -n "$COMP_WORDS" ]; then
    command "$@"
    return $?
  fi

  local basta_executing=y
  local realrows=$(( LINES + basta_prev_reserved_rows + 1 ))
  local i
  local exit=0
  local saveint=$(trap -p INT)
  local saveterm=
  local force=
  local ttyfd

  while true; do
    case $1 in
    ( -s )
      saveterm=y
      ;;
    ( -f )
      force=y
      ;;
    ( -sf | -fs )
      saveterm=y
      force=y
      ;;
    ( * )
      break
      ;;
    esac
    shift
  done

  local args=$(printf "%q " "$@")

  if ! [ -t 1 ] && ! [ $force ] ; then
    eval command "$args"
    return $?
  fi

  trap : INT

  exec {ttyfd}<>/dev/tty

  if [ $saveterm ] ; then
    printf $'\e[?1049h' >&$ttyfd
  else
    basta_deferred_intr=WINCH
    printf $'\e[J' >&$ttyfd
  fi

  printf $'\e7\e[1;%sr\e8' $realrows >&$ttyfd
  stty rows $realrows <&$ttyfd

  LINES=$realrows eval command "$args" || exit=$?

  if [ $saveterm ] ; then
    printf $'\e[?1049l' >&$ttyfd
  else
    basta.ensure_bottom_margin $LINES >&$ttyfd
  fi

  exec {ttyfd}>&-

  eval "$saveint"

  return $exit
}

# Initialization mainline

basta.install_hooks

if ! [ $basta_status_alarm_pid ] ; then
  basta.alarm_timer &
  basta_status_alarm_pid=$!
  disown $!
fi

basta.import_array LC_basta_status

# workaround for GNU Readline behavior whereby each time it
# receives a SIGALRM, it emits cruft to the terminal.
bind 'set enable-bracketed-paste 0'

basta_executing=

# Copyright 2023-2025
# Kaz Kylheku <kaz@kylheku.com>
# Vancouver, Canada
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following condition is met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form need not reproduce any copyright notice.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
