#!/bin/bash

set -e

die() {
    echo -e "$2"
    exit $1
}

[[ -n "$AS_ID" ]] || die 2 'You must run container with "-e AS_ID=$UID".\nNote: $UID is assumed to also be your GID.'
[[ -n "$AS_USER" ]] || die 3 'You must run container with "-e AS_USER=$USER".'
[[ -d "/home/$AS_USER" ]] || die 4 'You must run container with "-v /home/$USER:$HOME" or "-v /home/$USER:$HOME:z".'

groupadd -g "$AS_ID" "$AS_USER"
useradd -g "$AS_ID" -u "$AS_ID" --no-create-home "$AS_USER"
if ! [[ -r "/home/$AS_USER/.config/gcloud/configurations/config_default" ]]
then  # gcloud has not been initialized, do that first
    echo "Warning: no gcloud configuration found, you may want to run the 'init' subcommand to set it up."
fi
sudo --preserve-env --set-home --user "$AS_USER" --login --stdin /usr/bin/gcloud "$@"
