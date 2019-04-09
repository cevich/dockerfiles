#!/bin/bash

set -e

cd "$(realpath $(dirname $0))"
source ./lib.sh

[[ "$TRAVIS_BRANCH" == "master" ]] || exit 0  # Not running against merged code
