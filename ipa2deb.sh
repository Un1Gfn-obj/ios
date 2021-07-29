#!/bin/bash

# https://mrvirk.com/how-to-find-app-bundle-id-ios.html
IPAPATH="Shadowrocket_2.1.82_Telefonbuchios14ok.ipa"
PACKAGE="com.liguangming.Shadowrocket"
EXTRACT="/tmp/$PACKAGE"

echo

if [ -e "$EXTRACT" ]; then
  read -erp "remove $EXTRACT? "
  echo
  rm -rf "$EXTRACT"
fi

unzip "$IPAPATH" -d "$EXTRACT"
echo

mv -v "$EXTRACT/Payload" "$EXTRACT/Applications"
echo

# https://iphonedev.wiki/index.php/Packaging
# https://www.debian.org/doc/debian-policy/ch-controlfields.html#binary-package-control-files-debian-control
mkdir -v "$EXTRACT/DEBIAN"
echo
cat <<EOM >"$EXTRACT/DEBIAN/control"
Name: Shadowrocket
Package: $PACKAGE
Version: 2.1.82
Section: Applications
Architecture: iphoneos-arm
Maintainer: Shadow Launch Technology Limited
Description: Rule based proxy utility client for iPhone/iPad
EOM
cat "$EXTRACT/DEBIAN/control"
echo

dpkg -b "$EXTRACT" "$IPAPATH.deb"
echo
