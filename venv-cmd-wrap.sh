#!/bin/bash

set -e

if [[ ! -d "$seed_workspace" ]]
then
    echo "ERROR: Container Image does not have a valid \$seed_workspace value."
    exit 1
fi

if [[ -n "$WORKSPACE" ]]
then
    if [[ "$WORKSPACE" != "$seed_workspace" ]]
    then
        mkdir -p "$WORKSPACE"
        cp -au "${seed_workspace}"/* "${seed_workspace}"/.??* "$WORKSPACE"/
    fi
    cd $WORKSPACE
    exec ./venv-cmd.sh "$@"
fi
