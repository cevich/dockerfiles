#!/bin/bash

set -e

cd "$(realpath $(dirname $0))"
source ./lib.sh

# We can't rely on docker's auto-builds for testing purposes, because
# they occur only _after_ a merge.  Otherwise we could just 'docker pull...'.
docker build -f ${FQIN}.dockerfile -t ${FQIN}:${TAG} ./
