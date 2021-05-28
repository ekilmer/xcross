#!/bin/bash
# Run a given test.

scriptdir=`realpath $(dirname "$BASH_SOURCE")`
echo "$scriptdir"

cmd="$1"
image="$2"
toolchain="$3"
if [ -z "$3" ]; then
    toolchain="$image"
fi

docker run -v "$scriptdir:/test" \
    ahuszagh/cross:"$image" \
    /bin/bash -c "/test/$cmd.sh $toolchain"
