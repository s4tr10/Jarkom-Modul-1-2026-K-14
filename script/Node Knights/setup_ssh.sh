#!/bin/bash

apk update
apk add openssh busybox-extras
ssh-keygen -A
/usr/sbin/sshd
httpd -p 80