#!/bin/bash

set -xeo pipefail

case "$img_name" in
    *fedora*)
        UPDATE_CMD='dnf update -y'
        PREINST_CMD='dnf install -y findutils'
        INSTALL_CMD='dnf install -y'
        ;;
    *centos*)
        UPDATE_CMD='yum update -y'
        PREINST_CMD='yum install -y epel-release findutils'
        INSTALL_CMD='yum install -y'
        ;;
    *ubuntu*)
        UPDATE_CMD='apt-get -qq update'
        PREINST_CMD=''
        INSTALL_CMD='apt-get -qq install'
        ;;
    *)
        echo "This script is intended to be called as part of the docker build process,"
        echo "by a Dockerfile in one of the subdirectories of this repo.  It's not intended"
        echo "to be executed by hand."
        exit 1
        ;;
esac

$UPDATE_CMD

if [ -n "$PREINS_CMD" ]
then
    $PREINST_CMD
fi

cat /root/${img_name}.packages | xargs $INSTALL_CMD

rm -f /root/${img_name}.packages /root/install.sh
