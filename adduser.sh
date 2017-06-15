#!/bin/bash

[ ! -z $1 ] || echo "ENTER USERNAME"
[ ! -z $1 ] || exit 1

pass=`openssl rand -base64 10`;
groupadd chroot 2>/dev/null
adduser --groups chroot,$2 $1 ;
/bin/cp -fa /home/$1 /chroot/home/$1
echo -e "$pass\n$pass" | (passwd --stdin $1)

#
echo "exit 0" > /home/$1/.bashrc
chage -d 0 $1;

echo "$1 member of"
lid $1
echo
echo "$1 => $pass"

/bin/cp -fa /etc/passwd /chroot/etc/passwd 
/bin/cp -fa /etc/group /chroot/etc/group 
