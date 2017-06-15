#!/bin/bash

[ ! -z $1 ] || echo "ENTER USERNAME"
[ ! -z $1 ] || exit 1

pass=`openssl rand -base64 10`;
groupadd chroot 2>/dev/null

if [ -z $2 ]; then
  adduser --groups chroot $1
  usermod -G chroot $1
elif [ $2 == 'admin' ]; then
  adduser --groups chroot,$2 $1
  usermod -G chroot,$2 $1
else
  echo "It is not admin group"
fi

/bin/cp -fa /home/$1 /chroot/home/$1
echo -e "$pass\n$pass" | (passwd --stdin $1)
chage -d 0 $1;

#DISABLE BASH NOT IN CHROOT
echo "exit 0" > /home/$1/.bashrc

#
echo
echo "$1 member of:"
lid $1
echo
echo "TEMPORARY password was created"
echo "$1 => $pass"

#
/bin/cp -fa /etc/passwd /chroot/etc/passwd 
/bin/cp -fa /etc/group /chroot/etc/group 
