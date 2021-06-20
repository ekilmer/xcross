#!/bin/bash
#
# Build a cross-installation of GCC with custom patches.

set -ex

# Check required environment variables.
if [ "$ARCH" = "" ]; then
    echo 'Must set the host architecture via `$ARCH`, quitting.'
    exit 1
fi

export DEBIAN_FRONTEND="noninteractive"

# Install dependencies. We store the installed
# dependencies so we don't accidentally delete
# necessary files, and we get rid of everything
# that was only required for the build.
# python3 is for glibc
# python3-pip and python3-dev for gdb
apt-get update
before_installed=($(apt -qq list --installed 2>/dev/null | cut -d '/' -f 1))
apt-get install --assume-yes --no-install-recommends \
    autoconf \
    bison \
    flex \
    g++ \
    gawk \
    help2man \
    libncurses-dev \
    libtool-bin \
    patch \
    python3 \
    python3-dev \
    python3-pip \
    texinfo \
    unzip \
    wget \
    xz-utils
after_installed=($(apt -qq list --installed 2>/dev/null | cut -d '/' -f 1))

# Calculate the packages we need to remove later.
diff=()
for i in "${after_installed[@]}"; do
    skip=
    for j in "${before_installed[@]}"; do
        [[ $i == $j ]] && { skip=1; break; }
    done
    [[ -n $skip ]] || diff+=("$i")
done
declare -p diff

# Create a source directory for easy cleanup.
mkdir -p src && cd src

# Build ct-ng
ctng_version="1.24.0"
wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-"$ctng_version".tar.xz
tar xvf crosstool-ng-"$ctng_version".tar.xz
cd crosstool-ng-"$ctng_version"
./configure --prefix=/src/crosstoolng
make -j 5
make install

# Toolchains can be built using:
#   ct-ng menuconfig
#
# Make sure to set under "Target options":
#   Target Architecture
#   ABI
#   Bitness
#   Endianness
#
# Make sure to set under "Toolchain Options":
#   Build Static Toolchain
#
# Make sure to set under "Operating System":
#   Target OS
#
# Make sure to set under "C compiler":
#   C++
#
# The config then needs to be patched to set:
#   CT_GCC_V_10=y
#   # CT_GCC_V_9 is not set
#   CT_GCC_VERSION="10.2.0"
#
# If using GLIBC, then we need to patch the config to set:
#   CT_GLIBC_V_2_31=y
#   # CT_GLIBC_V_2_30 is not set
#   # CT_GLIBC_V_2_29 is not set
#   CT_GLIBC_VERSION="2.31"

# Copy config files over and build our toolchain.
# When debugging, use `CT_DEBUG_CT_SAVE_STEPS=1 ct-ng build`
# so the build can restart. Find the offending step via
# `ct-ng list-steps`, and then restart via
# `RESTART=$step ct-ng build`. This dramatically speeds up
# debugging new builds.
cd /src
mkdir ct-ng-build
chown -R crosstoolng:crosstoolng ct-ng-build
cd ct-ng-build
cp /ct-ng/"$ARCH".config .config
chown crosstoolng:crosstoolng .config

# Build up until we have the dependencies for the host.
# We do the build in 2 steps: first stop after an initial step,
# then restart the build after patching the libraries.
step=companion_tools_for_build
cd /src/ct-ng-build
su crosstoolng -c "mkdir -p /home/crosstoolng/src"
su crosstoolng -c "STOP=$step CT_DEBUG_CT_SAVE_STEPS=1 /src/crosstoolng/bin/ct-ng build.5"

# Apply the diffs.
for patch in /src/diff/*.sh; do
    "$patch"
done

# Re-run the build with the applied patches.
su crosstoolng -c "RESTART=$step CT_DEBUG_CT_SAVE_STEPS=1 /src/crosstoolng/bin/ct-ng build.5"

# Cleanup
# Even though we didn't install GCC, it doesn't get autoremoved,
# which takes up a lot of space.
cd /
rm -rf /src
rm -rf /home/crosstoolng/src
apt-get remove --purge --assume-yes "${diff[@]}"
apt-get autoremove --assume-yes
