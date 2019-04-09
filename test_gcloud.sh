#!/bin/bash

set -e

cd "$(realpath $(dirname $0))"
source ./lib.sh

set -x

# Run $2 check for output, exit code $3, and regex $4, or exit(code + $1)
test_expectations(){
    EBASE="$1"
    CMD="$2"
    EEXIT="$3"
    RX="$4"
    rm -f /tmp/output
    set +e
    $CMD ${FQIN}:${TAG} &> /tmp/output
    RET=$?
    cat /tmp/output
    set -e
    [[ -r "/tmp/output" ]] || exit $[EBASE+1]
    [[ "$RET" -eq "$EEXIT" ]] || exit $[EBASE+2]
    egrep -i "$RX" /tmp/output || exit $[EBASE+3]
}

# Expect an error mesage about passing AS_ID option and a "2" exit code
CMD="docker run --attach=STDOUT --attach=STDERR --rm"
test_expectations 0 "$CMD" 2 'AS_ID=\$UID'

# Expect an error message about passing AS_USER and a "3" exit code
CMD="$CMD -e AS_ID=$UID"
test_expectations 3 "$CMD" 3 'AS_USER=\$USER'

# Expect an error message about /home/$USER:$HOME"  and a "4" exit code
CMD="$CMD -e AS_USER=$USER"
test_expectations 5 "$CMD" 4 '/home/\$USER:\$HOME'

if [[ "$FQIN" == "gcloud_centos" ]]
then
    # expect gcloud to exit 2 and produce usage message output
    CMD="$CMD -v /home/$USER:$HOME:z"
    test_expectations 7 "$CMD" 2 'Command name argument expected'
elif [[ "$FQIN" == "gsutil_centos" ]]
then
    # expect gsutil to exit  and produce usage message output
    CMD="$CMD -v /home/$USER:$HOME:z"
    test_expectations 11 "$CMD" 0 'Concatenate object content to stdout'
else
    echo "Unsupported \$FQIN=$FQIN"
    exit 17
fi
