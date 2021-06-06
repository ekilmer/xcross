#!/bin/bash

scriptdir=`realpath $(dirname "$BASH_SOURCE")`
source "$scriptdir/shortcut.sh"

export PREFIX=aarch64-unknown-elf
export DIR=/home/crosstoolng/x-tools/"$PREFIX"/

CFLAGS="-nostartfiles" shortcut_gcc
shortcut_util
