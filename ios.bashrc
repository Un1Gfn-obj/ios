#!/dev/null

# function get_ip {
#   [[ -z "$OCTET_LSB" ]] && read -erp "iOS address: 192.168.1." OCTET_LSB
#   { [[ "$OCTET_LSB" -ge 2 ]] && [[ "$OCTET_LSB" -le 254 ]] } || { echo "${FUNCNAME[0]}: error"; return 1; }
# }

function online {
  pgrep iproxy || { \
    echo
    echo    "  ${FUNCNAME[0]}: error"
    echo    "  make sure Lightning to USB cable is connected"
    echo -e "  run \033[4msudo iproxy 2222 22\033[24m in another terminal"
    echo
    return 1
  }
}

function set_up_alias {

  # Built item list
  # shellcheck disable=SC2155
  local SECRET="$(dirname "${BASH_SOURCE[0]}")/secret.bashrc"
  # shellcheck disable=SC1090
  { [ -f "$SECRET" ] && source "$SECRET"; } || { echo "${FUNCNAME[0]}: error2"; return 1; } # IP=""
  local CHOICES=(
    "(iproxy usb) [mobile@127.0.0.1:2222]$  "
    "(iproxy usb)   [root@127.0.0.1:2222]#  "
    "   (lan)      [mobile@$IP]$  "
    "   (lan)        [root@$IP]#  "
  )
  # shellcheck disable=SC2155
  local ITEMS="$( for ((i=0;i<${#CHOICES[@]};++i)); do echo "$i" "\"${CHOICES[$i]}\""; done )"

  # Remember previously selected menu item
  local PREV="/tmp/ios_ssh.choice"
  local DEFAULT="0"
  if [ -f "$PREV" ]; then
    # shellcheck disable=SC2155
    local N=$(<"$PREV")
    { [ "$N" -ge 0 ] && [ "$N" -lt "${#CHOICES[@]}" ]; } || { echo "${FUNCNAME[0]}: error1"; return 1; }
    DEFAULT="$N"
  fi

  # Preform selection w/ menu
  # https://stackoverflow.com/questions/13426908/dialog-in-bash-is-not-grabbing-variables-correctly
  # https://askubuntu.com/questions/491509/how-to-get-dialog-box-input-directed-to-a-variable
  local result=""
  exec 3>&1
  result="$( xargs env TERM=xterm-256color dialog --default-item "$DEFAULT" --menu TEXT $((4+8)) $((1+2+38+7)) 4 <<<"$ITEMS" 2>&1 1>&3 )"
  local R="$?"
  exec 3>&-;

  # Set up alias
  [ "$R" -eq 0 ] || { echo "${FUNCNAME[0]}: error3"; return 1; }
  # shellcheck disable=SC2139
  case "$result" in
    0) alias ssh="online && /usr/bin/env TERM=xterm-256color /usr/bin/ssh 127.0.0.1 -p 2222 -l mobile" ; echo "$result" >"$PREV" ;;
    1) alias ssh="online && /usr/bin/env TERM=xterm-256color /usr/bin/ssh 127.0.0.1 -p 2222 -l root"   ; echo "$result" >"$PREV" ;;
    2) alias ssh="          /usr/bin/env TERM=xterm-256color /usr/bin/ssh $IP       -p 22   -l mobile" ; echo "$result" >"$PREV" ;;
    3) alias ssh="          /usr/bin/env TERM=xterm-256color /usr/bin/ssh $IP       -p 22   -l root"   ; echo "$result" >"$PREV" ;;
    *) { echo "${FUNCNAME[0]}: error4"; return 1; } ;;
  esac
  clear
  echo -n "[$result] "; alias ssh
  echo

}

set_up_alias

