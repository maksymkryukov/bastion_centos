#!/bin/bash

# Set CHROOT directory name
BASE="/chroot"

groupadd admin 2>/dev/null


/usr/bin/ls /$1 >/dev/null 2>&1
if  [ $? -gt 0 ]; then
        echo NEED FULL PATH
        exit 1
fi

BINF=$1
/bin/cp -fv $BINF ${BASE}${BINF}

[ $2 == 'admin'] && \
        chmod 550 ${BASE}${BINF} && chgrp admin ${BASE}${BINF}


[ -f ${BASE}${BINF} ] || exit 1

if [ $# -eq 0 ]; then
  echo "Syntax : $0 /path/to/executable"
  exit 1
fi

[ ! -d $BASE ] && mkdir -p $BASE || :

FILES="$(ldd $BINF | awk '{ print $3 }' |egrep -v ^'\(')"

echo "Copying shared files/libs to $BASE..."
for i in $FILES
do
  d="$(dirname $i)"
  [ ! -d $BASE$d ] && mkdir -p $BASE$d || :
  /bin/cp $i $BASE$d
done

# copy /lib/ld-linux* or /lib64/ld-linux* to $BASE/$sldlsubdir
# get ld-linux full file location
sldl="$(ldd $BINF | grep 'ld-linux' | awk '{ print $1}')"
# now get sub-dir
sldlsubdir="$(dirname $sldl)"

if [ ! -f $BASE$sldl ];
then
  echo "Copying $sldl $BASE$sldlsubdir..."
  /bin/cp $sldl $BASE$sldlsubdir
else
  :
fi
