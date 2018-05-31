#!/bin/bash

set -e

cd "$(realpath $(dirname $0))"
source ./lib.sh

[[ "$TRAVIS_BRANCH" == "master" ]] || exit 0  # Not running against merged code

curl -H "Content-Type: application/json" \
     --data '{"docker_tag": "master"}' \
     -X POST \
     "https://registry.hub.docker.com/u/cevich/${FQIN_PFX}_${FQIN_SFX}/trigger/$TOKEN/"
