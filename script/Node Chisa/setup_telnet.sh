#!/bin/bash
apk update
apk add busybox-extras

adduser -D phantom_user 2>/dev/null

echo "phantom_user:wired_ghost" | chpasswd

killall telnetd 2>/dev/null
telnetd

echo "Telnet Server sudah menyala dan siap menerima koneksi!"