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

function select_alias {

  { [ -f secret.bashrc ] && source secret.bashrc; } || { echo "${FUNCNAME[0]}: error1"; return 1; }

  # https://stackoverflow.com/questions/13426908/dialog-in-bash-is-not-grabbing-variables-correctly
  # https://askubuntu.com/questions/491509/how-to-get-dialog-box-input-directed-to-a-variable
  exec 3>&1 
  result=$( env TERM=xterm-256color dialog --menu TEXT $((4+8)) $((1+2+38+7)) 4 \
    0 "(iproxy usb) [mobile@127.0.0.1:2222]$ " \
    1 "(iproxy usb)   [root@127.0.0.1:2222]# " \
    2 "   (lan)      [mobile@$IP]$ " \
    3 "   (lan)        [root@$IP]# " \
  2>&1 1>&3 );
  local R="$?"
  exec 3>&-;

  [ "$R" -eq 0 ] || { echo "${FUNCNAME[0]}: error2"; return 1; }
  case "$result" in
    0) alias ssh="online && /usr/bin/env TERM=xterm-256color /usr/bin/ssh 127.0.0.1 -p 2222 -l mobile" ;;
    1) alias ssh="online && /usr/bin/env TERM=xterm-256color /usr/bin/ssh 127.0.0.1 -p 2222 -l root"   ;;
    2) alias ssh="          /usr/bin/env TERM=xterm-256color /usr/bin/ssh $IP       -p 22   -l mobile" ;;
    3) alias ssh="          /usr/bin/env TERM=xterm-256color /usr/bin/ssh $IP       -p 22   -l root"   ;;
    *) { echo "${FUNCNAME[0]}: error3"; return 1; } ;;
  esac

  clear
  alias ssh
  echo

}

select_alias
