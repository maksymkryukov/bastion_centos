#!/bin/bash


array=(etc home var usr tmp dev lib64 bin)

echo ""
echo "By default will be created $DEFDIR"
echo ""
        
CHROOT=chroot

        if  [ ! -d /$CHROOT ] 
           then
                   echo "Create Dir /$CHROOT and ${array[@]}"
                   mkdir -p /${CHROOT}/{etc,var,dev,home,lib64,bin,tmp,usr/{lib64,bin,sbin,local/bin}}
                   ls -1R /${CHROOT}  | sed '/^$/d'
     		  		
  					chmod go-w 	/${CHROOT}
      					chmod 777 	/${CHROOT}/tmp
      					mknod -m 666 	/${CHROOT}/dev/tty c 5 0
					mknod -m 666 	/${CHROOT}/dev/null c 1 3
					mknod -m 444 	/${CHROOT}/dev/random c 1 8
					mknod -m 444 	/${CHROOT}/dev/urandom c 1 9
					chown root:tty 	/${CHROOT}/dev/tty
					cd /etc
                                        cp -pr  group hosts ld.so.cache ld.so.conf ld.so.conf.d nsswitch.conf passwd profile resolv.conf /${CHROOT}/etc
                                        cd /dev ; cp -rp console fd full fuse mqueue ptmx pts  shm stderr stdin stdout  zero /${CHROOT}/dev
                                        cp -rp /usr/lib64/*nss* /${CHROOT}/usr/lib64/


cat > /${CHROOT}/etc/bashrc <<EOF
PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
[ -f ~/.google_authenticator ] || google-authenticator --qr-mode=utf8 -tdf --rate-limit=3 --rate-time=30 --window-size=10
EOF

                                      
				echo "The ${CHROOT} created "
           else
               echo "The directory is already used."

        fi
	echo ""


