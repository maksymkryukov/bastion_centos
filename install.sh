#!/bin/bash

    sudo sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config && setenforce 0
    yum -y groupinstall "Development Tools"
    yum -y install pam-devel wget
    yum -y install autoconf automake bind-utils gcc libtool make nmap-netcat ntp pam-devel unzip wget
    yum -y install ntp
    systemctl start ntpd
    systemctl enable ntpd
    cd /opt
    wget -q https://github.com/google/google-authenticator-libpam/archive/master.zip
    unzip master.zip
    cd google-authenticator-libpam-master/
    ./bootstrap.sh
    ./configure
    make
    sudo make install
