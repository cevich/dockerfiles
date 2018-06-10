#!/bin/bash

set -xeo pipefail

MARKER="# Added by $0"
VENVURI="${VENVURI:-https://raw.githubusercontent.com/cevich/ADEPT/master/venv-cmd.sh}"
VENVREQ="${VENVREQ:-https://raw.githubusercontent.com/cevich/ADEPT/master/requirements.txt}"

case "$img_name" in
    *fedora*)
        UPDATE_CMD='dnf update -y'
        PREINST_CMD='dnf install -y findutils'
        INSTALL_CMD='dnf install -y'
        CLEAN_CMD='dnf clean all'
        ;;
    *centos*)
        UPDATE_CMD='yum update -y'
        PREINST_CMD='yum install -y epel-release findutils'
        INSTALL_CMD='yum install -y'
        CLEAN_CMD='yum clean all'
        ;;
    *test_rhsm*)
        UPDATE_CMD='yum update -y'
        PREINST_CMD='yum install -y epel-release'
        INSTALL_CMD='yum install -y'
        CLEAN_CMD='yum clean all'
        ;;
    *ubuntu*)
        UPDATE_CMD='apt-get -qq update'
        PREINST_CMD=''
        INSTALL_CMD='apt-get -qq install'
        CLEAN_CMD='apt-get -qq clean'
        ;;
    *)
        echo "This script is intended to be called as part of the docker build process,"
        echo "by a Dockerfile in one of the subdirectories of this repo.  It's not intended"
        echo "to be executed by hand."
        exit 1
        ;;
esac

if ! grep "$MARKER" /root/.bashrc
then
    (
        echo "$MARKER"
        echo 'PATH=${PATH}:/root/bin'
    ) >> /root/.bashrc
fi

for CMD in "$UPDATE_CMD" "$PREINST_CMD"
do
    if [[ -n "$CMD" ]]; then $CMD; fi
done

cat /root/${img_name}.packages | xargs $INSTALL_CMD

if [[ -n "$CLEAN_CMD" ]]; then $CLEAN_CMD; fi

if [[ -n "$seed_workspace" ]]
then  # this is a venv_* image
    mkdir -p "$seed_workspace"
    cd "$seed_workspace"
    for URL in "$VENVURI" "$VENVREQ"
    do
        curl --remote-name "$URL"
    done
    chmod 755 ./venv-cmd.sh
    # Seed .cache and .venv contents
    env WORKSPACE="$seed_workspace" ./venv-cmd.sh ansible-playbook --version
fi
