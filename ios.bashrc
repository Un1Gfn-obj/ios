#!/dev/null

# function get_ip {
#   [[ -z "$OCTET_LSB" ]] && read -erp "iOS address: 192.168.1." OCTET_LSB
#   { [[ "$OCTET_LSB" -ge 2 ]] && [[ "$OCTET_LSB" -le 254 ]] } || { echo "${FUNCNAME[0]}: error"; return 1; }
# }

function online {
  [ "$THEOS_DEVICE_IP" = "127.0.0.1" ] || return 0
  pgrep iproxy || { \
    echo
    echo    "  ${FUNCNAME[0]}: error"
    echo    "  make sure Lightning to USB cable is connected"
    echo -e "  run \033[4msudo iproxy 2222 22\033[24m in another terminal"
    echo
    return 1
  }
}

function ssh2 {
  online || { echo "${FUNCNAME[0]}: error"; return 1; }
  /usr/bin/env TERM=xterm-256color /usr/bin/ssh "$THEOS_DEVICE_IP" -p "$THEOS_DEVICE_PORT" -l "$THEOS_LOGIN" "$@"
}

function scp2 {
  online || { echo "${FUNCNAME[0]}: error"; return 1; }
  [ "$#" -ge 1 ] || { echo "${FUNCNAME[0]}: error2"; return 1; }
  echo "copy to $(ssh2 pwd) ..."
  /usr/bin/scp -P "$THEOS_DEVICE_PORT" "$@" "$THEOS_LOGIN"@"$THEOS_DEVICE_IP":/private/var/mobile/
}

function scp3 {
  online || { echo "${FUNCNAME[0]}: error1"; return 1; }
  [ "$#" -eq 1 ] || { echo "${FUNCNAME[0]}: error2"; return 1; }
  read -erp "  $1 -> $PWD/ ?"
  /usr/bin/scp -rP "$THEOS_DEVICE_PORT" "$THEOS_LOGIN"@"$THEOS_DEVICE_IP":"$1" ./
}

# function scp3 {
#   [ "$#" -eq 3 ] || { echo "${FUNCNAME[0]}: error2"; return 1; }
#   scp ${@:1:$#-1} "$3"
# }

function export_port_ip_login {

  # Built item list
  # shellcheck disable=SC2155
  local SECRET="$(dirname "${BASH_SOURCE[0]}")/secret.bashrc"
  export THEOS_DEVICE_IP
  # shellcheck disable=SC1090
  { [ -f "$SECRET" ] && source "$SECRET"; } || { echo "${FUNCNAME[0]}: error2"; return 1; } # IP=""
  local CHOICES=(
    "(iproxy usb) [mobile@127.0.0.1:2222]$  "
    "(iproxy usb)   [root@127.0.0.1:2222]#  "
    "   (lan)      [mobile@$THEOS_DEVICE_IP]$  "
    "   (lan)        [root@$THEOS_DEVICE_IP]#  "
  )
  # shellcheck disable=SC2155
  local ITEMS="$( for ((i=0;i<${#CHOICES[@]};++i)); do echo "$i" "\"${CHOICES[$i]}\""; done )"
  local MAXLEN=0
  for i in "${CHOICES[@]}"; do
    [ "${#i}" -gt "$MAXLEN" ] && MAXLEN=${#i}
  done

  # Remember previously selected menu item
  local PREV="/tmp/ios_ssh.choice"
  local DEFAULT="0"
  if [ -f "$PREV" ]; then
    # shellcheck disable=SC2155
    local N=$(<"$PREV")
    { [ "$N" -ge 0 ] && [ "$N" -lt "${#CHOICES[@]}" ]; } || { echo "${FUNCNAME[0]}: error1"; return 1; }
    DEFAULT="$N"
  fi

  # Dialog
  # https://stackoverflow.com/questions/13426908/dialog-in-bash-is-not-grabbing-variables-correctly
  # https://askubuntu.com/questions/491509/how-to-get-dialog-box-input-directed-to-a-variable
  local result=""
  exec 3>&1
  result="$( xargs env TERM=xterm-256color dialog --default-item "$DEFAULT" --menu "select 'ssh2' destination" $((${#CHOICES[@]}+8)) $((1+2+MAXLEN+7)) 4 <<<"$ITEMS" 2>&1 1>&3 )"
  local R="$?"
  exec 3>&-;
  [ "$R" -eq 0 ] || { echo "${FUNCNAME[0]}: error3"; return 1; }
  clear

  # Save result
  { [ "$result" -ge 0 ] && [ "$result" -lt "${#CHOICES[@]}" ]; } || { echo "${FUNCNAME[0]}: error4"; return 1; }
  echo "$result" >"$PREV"

  # Set up ssh alias
  # shellcheck disable=SC2139
  case "$result" in
    0) export THEOS_DEVICE_PORT=2222 THEOS_DEVICE_IP=127.0.0.1 THEOS_LOGIN=mobile ;;
    1) export THEOS_DEVICE_PORT=2222 THEOS_DEVICE_IP=127.0.0.1 THEOS_LOGIN=root   ;;
    2) export THEOS_DEVICE_PORT=22                             THEOS_LOGIN=mobile ;;
    3) export THEOS_DEVICE_PORT=22                             THEOS_LOGIN=root   ;;
  esac
  echo -n "[$result] "
  echo "$THEOS_LOGIN@$THEOS_DEVICE_IP:$THEOS_DEVICE_PORT"

}


# https://iphonedevwiki.net/index.php/Theos#Theos_variables
function export_theos_variables {
  export_port_ip_login
  export THEOS=/opt/theos
  export ARCHS=(arm64)
  export TARGET="iphone:clang:14.4:14.4"
  export sysroot="$THEOS/sdks/iPhoneOS14.4.sdk"
  export DEBUG=1
}

export_theos_variables

# For Makefile
export -f online
export -f ssh2
export -f scp2

# https://github.com/alacritty/alacritty/issues/1636#issuecomment-427885737
echo -e "\033]0;ios\007"
