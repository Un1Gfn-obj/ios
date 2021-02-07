#!/dev/null

source secret.bashrc

function ssh_lan {
  # [[ -z "$OCTET_LSB" ]] && read -erp "iOS address: 192.168.1." OCTET_LSB
  # { [[ "$OCTET_LSB" -ge 2 ]] && [[ "$OCTET_LSB" -le 254 ]] } || { echo "${FUNCNAME[0]}: error"; return 1; }
  /usr/bin/env TERM=xterm-256color /usr/bin/ssh "$IP" -p 22 "$@"
}

function ssh_usb {
  pgrep iproxy || { \
    echo
    echo    "${FUNCNAME[0]}: error"
    echo    "make sure Lightning to USB cable is connected"
    echo -e "run \033[4msudo iproxy 2222 22\033[24m in another terminal"
    echo
    return 1
  }
  /usr/bin/env TERM=xterm-256color /usr/bin/ssh 127.0.0.1 -p 2222 "$@"
}

# alias ssh='ssh_lan -l mobile'
# alias sshr='ssh_lan -l mobile'
alias ssh='ssh_usb -l mobile'
alias sshr='ssh_usb -l root'
