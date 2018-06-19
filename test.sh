#!/bin/bash

set -e

cd "$(realpath $(dirname $0))"
source ./lib.sh
export REPO_NAME=$(basename $(git rev-parse --show-toplevel))
export WORKDIRNAME="${TRAVIS_REPO_SLUG:-$REPO_NAME}"
export TRAVIS_BUILD_DIR="${TRAVIS_BUILD_DIR:-/root/$WORKDIRNAME}"

# Volume-mounting the repo into the SPC makes a giant mess of permissions
# on the host.  This really sucks for developers, so make a copy for use
# in the SPC separate from the host, throw it away when this script exits.
echo
echo "Making temporary copy of $PWD that will appear in SPC as $TRAVIS_BUILD_DIR"
TMP_SPC_REPO_COPY=$(mktemp -p '' -d ${REPO_NAME}_XXXXXX)
trap "sudo rm -rf $TMP_SPC_REPO_COPY" EXIT
/usr/bin/rsync --recursive --links --delete-after --quiet \
               --delay-updates --whole-file --safe-links \
               --perms --times --checksum "${PWD}/" "${TMP_SPC_REPO_COPY}/"

export SPC_ARGS="--interactive --rm --privileged --ipc=host --pid=host --net=host"

export ENV_ARGS="-e HOME=/root
                 -e SHELL=${SHELL:-/bin/bash}
                 -e TRAVIS=${TRAVIS:-false}
                 -e CI=$CI
                 -e TRAVIS_COMMIT=$TRAVIS_COMMIT
                 -e TRAVIS_COMMIT_RANGE=$TRAVIS_COMMIT_RANGE
                 -e TRAVIS_REPO_SLUG=$WORKDIRNAME
                 -e TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST
                 -e TRAVIS_PULL_REQUEST_SHA=$TRAVIS_PULL_REQUEST_SHA
                 -e TRAVIS_PULL_REQUEST_SLUG=$TRAVIS_PULL_REQUEST_SLUG
                 -e TRAVIS_BRANCH=$TRAVIS_BRANCH
                 -e TRAVIS_JOB_ID=$TRAVIS_JOB_ID
                 -e TRAVIS_BUILD_DIR=$TRAVIS_BUILD_DIR"

export VOL_ARGS="-v $TMP_SPC_REPO_COPY:$TRAVIS_BUILD_DIR
                 -v /run:/run -v /etc/localtime:/etc/localtime
                 -v /var/log:/var/log -v /sys/fs/cgroup:/sys/fs/cgroup
                 -v /var/run/docker.sock:/var/run/docker.sock
                 --workdir $TRAVIS_BUILD_DIR"

echo
echo "Host Environment:"
env | sort

CMD="docker run $SPC_ARGS $ENV_ARGS $VOL_ARGS ${FQIN}:${TAG} $SPC_CMD"
echo
echo "Executing: $CMD"
$CMD

if [[ "$FQIN_PFX" == "venv" ]] && [[ "$FQIN_SFX" == "centos" ]]
then
    echo
    echo "Testing dependant spc_centos image"
    docker run $SPC_ARGS $ENV_ARGS $VOL_ARGS spc_centos:latest podman --storage-driver vfs pull alpine
    docker run $SPC_ARGS $ENV_ARGS $VOL_ARGS spc_centos:latest ansible -i localhost, localhost -c local -m docker_container -a 'name=foobar detach=false image=centos state=present command=true cleanup=true interactive=true'
fi
