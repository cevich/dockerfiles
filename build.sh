#!/bin/bash

set -e

cd "$(realpath $(dirname $0))"
source ./lib.sh

# We can't rely on docker's auto-builds for testing purposes, because
# they occur only _after_ a merge.  Otherwise we could just 'docker pull...'.
docker build -f ${FQIN}.dockerfile -t ${FQIN}:${TAG} ./

# cevich/spc_centos depends on cevich/venv, build both for efficiency
if [[ "$FQIN_PFX" == "venv" ]] && [[ "$FQIN_SFX" == "centos" ]]
then
    echo
    echo "Building dependent spc_centos image"
    docker tag ${FQIN}:${TAG} cevich/${FQIN}:latest
    docker build -f spc_centos.dockerfile -t spc_centos:latest ./
fi
