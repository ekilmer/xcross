#!/bin/bash
# Get the current toolchains version.

# Currently uses the following toolchain versions:
#   Ubuntu          20.04
#   GCC             10.2.0
#   MinGW           8.0.0
#   glibc           2.31 or 2.32
#   musl            1.2.2
#   avr-libc        2.0.0
#   uclibc-ng       1.0.31
#   crosstool-ng    1.24.0
#
# Incrementing a major version of any of these dependencies
# will lead to a version increment.
export VERSION=0.1
