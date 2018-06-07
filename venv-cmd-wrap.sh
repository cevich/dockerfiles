#!/bin/bash

set -e

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
