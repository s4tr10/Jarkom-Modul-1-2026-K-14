#!/bin/bash
apk update
apk add vsftpd

# Setup direktori dan user
mkdir -p /var/wired/data
adduser -D alice
echo "alice:alice" | chpasswd
adduser -D mika
echo "mika:mika" | chpasswd
adduser -D eiri
echo "eiri:eiri" | chpasswd

# Setup permission folder
chown alice:root /var/wired/data
chmod 755 /var/wired/data

# Konfigurasi vsftpd
cat << 'CONF' > /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
listen=YES
listen_ipv6=NO
local_root=/var/wired/data
userlist_enable=YES
userlist_deny=YES
userlist_file=/etc/vsftpd.userlist
seccomp_sandbox=NO
CONF

# Setup blacklist
echo "eiri" > /etc/vsftpd.userlist

# Restart layanan vsftpd
killall vsftpd 2>/dev/null
vsftpd /etc/vsftpd/vsftpd.conf &