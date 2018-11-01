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
    *test_rhsm*) ;&  # continue to next item
    *centos*)
        UPDATE_CMD='yum update -y'
        PREINST_CMD='yum install -y epel-release findutils'
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

if [[ "$img_name" =~ "gcloud_centos" ]]
then
    # Update YUM with Cloud SDK repo information:
    cat << EOF > /etc/yum.repos.d/google-cloud-sdk.repo
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
fi

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
    echo "Configuring python virtual environment for Ansible"
    mkdir -p "$seed_workspace"
    cd "$seed_workspace"

    for URL in "$VENVURI" "$VENVREQ"
    do
        curl --remote-name "$URL"
    done
    chmod 755 ./venv-cmd.sh

    if [[ -n "$xtrareq" ]] && [[ -r "$xtrareq" ]]
    then  # Additional requirements are needed
        echo "Adding docker support to python virtual environment"
        cat "$xtrareq" >> ./requirements.txt
    fi

    echo "Seeding python virtual environment and cache contents"
    env WORKSPACE="$seed_workspace" ./venv-cmd.sh ansible-playbook --version
fi
