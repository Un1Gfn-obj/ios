### [iPhone Dev Wiki](https://iphonedevwiki.net/index.php/Main_Page)

[Theos](https://iphonedevwiki.net/index.php/Theos)

[CodeSigning](http://iphonedevwiki.net/index.php/Code_Signing)
*   [ldid](http://iphonedevwiki.net/index.php/Ldid)

[Getting_Started](http://iphonedevwiki.net/index.php/Getting_Started)
[Advice_for_new_developers](http://iphonedevwiki.net/index.php/Advice_for_new_developers)

---

### [the iPhone Wiki](https://www.theiphonewiki.com)

[SwitchBoard: /usr/local/bin](https://www.theiphonewiki.com/wiki/SwitchBoard:_/usr/local/bin)

[/System/Library/CoreServices/SpringBoard.app](https://www.theiphonewiki.com/wiki//System/Library/CoreServices/SpringBoard.app)

```plain
# uicache
```

[MarimbaRemix](https://www.zedge.net/find/ringtones/marimba%20remix)

[Cydia](https://www.theiphonewiki.com/wiki/Cydia.app)
*   [Errors](https://www.theiphonewiki.com/wiki/Cydia_Errors)
*   [CydiaSubstrate](https://www.theiphonewiki.com/wiki/Cydia_Substrate)
*   [PackageSearch](https://www.ios-repo-updates.com/)

[syslog](https://www.theiphonewiki.com/wiki/System_Log)

[ECID](https://www.theiphonewiki.com/wiki/ECID)

**Always save [SHSH](https://www.theiphonewiki.com/wiki/SHSH) before upgrading** ([Cydia_SHSH_Server](https://www.theiphonewiki.com/wiki/Cydia_SHSH_Server))

---

[iOS CFW Guide](https://ios.cfw.guide/)

[Repos](https://ios.cfw.guide/recommended-repos)

---

SO
[#cydia](https://stackoverflow.com/questions/tagged/cydia)
[SO#jailbreak](https://stackoverflow.com/questions/tagged/jailbreak)
[SO#theos](https://stackoverflow.com/questions/tagged/theos)

[D0m0/CocoaTop](https://github.com/D0m0/CocoaTop)

[r/jailbreak](https://www.reddit.com/r/jailbreak)

[Twickd Repo](https://repo.twickd.com/)

[iFixit](https://www.ifixit.com/)

---

/etc/passwd passwd(5)

```
$ ssh mobile@192.168.1.17 cat /etc/passwd | grep -v -e'^#' -e'^_' | cut -d: -f1,3- | column -o: -s: -t
nobody:-2 :-2 :Unprivileged User   :/var/empty :/usr/bin/false
root  :0  :0  :System Administrator:/var/root  :/bin/sh
mobile:501:501:Mobile User         :/var/mobile:/bin/sh
daemon:1  :1  :System Services     :/var/root  :/usr/bin/false
```

https://stackoverflow.com/questions/45464584/macosx-which-dynamic-libraries-linked-by-binary

```
export DYLD_PRINT_LIBRARIES=1
export DYLD_PRINT_LIBRARIES_POST_LAUNCH=1
export DYLD_PRINT_RPATHS=1
```

https://stackoverflow.com/questions/15202441/ios-6-x-open-command-line-on-jailbreak
