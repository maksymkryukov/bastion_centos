#!/bin/bash

    sudo sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config && setenforce 0
    yum install google-authenticator
