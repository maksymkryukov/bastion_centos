#!/bin/bash

groupadd chroot
groupadd emerge


/bin/cp /usr/local/lib/security/pam_google_authenticator.so /usr/lib64/security/pam_google_authenticator.so

/bin/bash bin_lib.sh /bin/bash
/bin/bash bin_lib.sh /usr/local/bin/google-authenticator
/bin/bash bin_lib.sh /usr/bin/id
/bin/bash bin_lib.sh /usr/bin/ssh

cat >> /etc/ssh/sshd_config <<EOF

AllowGroups ssh_access chroot emerge

Match Group chroot
     ChrootDirectory /chroot
     X11Forwarding yes
     AllowTcpForwarding yes
     AuthorizedKeysFile no

EOF

cat >> /etc/security/access.conf <<EOF
+ : root : cron crond
+ : (emerge) : 10.234.0.0/16
+ : (chroot) : ALL
- : ALL : ALL
EOF

/bin/cp -f /lib64/libqrencode.so.3 /chroot/lib64/
/bin/cp -f /lib64/libqrencode.so.3.4.1 /chroot/lib64/

sed -i '12 iaccount    required     pam_access.so' /etc/pam.d/system-auth 
sed -i '2 iauth       required     pam_google_authenticator.so secret=/home/${USER}/.google_authenticator  nullok' /etc/pam.d/sshd
sed -i '2 iauth       required     pam_google_authenticator.so secret=/chroot/home/${USER}/.google_authenticator  nullok' /etc/pam.d/sshd
sed -i '10 iaccount    required     pam_access.so' /etc/pam.d/sshd
sed -i "s/ChallengeResponseAuthentication .*/ChallengeResponseAuthentication yes/" /etc/ssh/sshd_config


####### CREATE emerge user
pass=`openssl rand -base64 10`;
  adduser --groups wheel -g emerge emerge ;
   echo -e "$pass\n$pass" | (passwd --stdin emerge)
    echo "emerge => $pass"

###########

systemctl reload sshd
