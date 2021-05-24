FROM ubuntu:20.04

# Update and add the cross-compiling utilities.
RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install --assume-yes --no-install-recommends \
    # Compilers
    g++-10-aarch64-linux-gnu \
    g++-10-arm-linux-gnueabi \
    g++-10-arm-linux-gnueabihf \
    g++-10-hppa-linux-gnu \
    g++-10-i686-linux-gnu \
    g++-10-m68k-linux-gnu \
    g++-10-mips-linux-gnu \
    g++-10-mips64-linux-gnuabi64 \
    g++-10-mips64el-linux-gnuabi64 \
    g++-10-mipsel-linux-gnu \
    g++-10-mipsisa32r6-linux-gnu \
    g++-10-mipsisa32r6el-linux-gnu \
    g++-10-mipsisa64r6-linux-gnuabi64 \
    g++-10-mipsisa64r6el-linux-gnuabi64 \
    g++-powerpc-linux-gnu \
    g++-powerpc64-linux-gnu \
    g++-powerpc64le-linux-gnu \
    g++-10-riscv64-linux-gnu \
    g++-10-s390x-linux-gnu \
    g++-10-sh4-linux-gnu \
    g++-10-sparc64-linux-gnu \
    g++-10-x86-64-linux-gnu \
    g++-10-x86-64-linux-gnux32 \
    g++-10-alpha-linux-gnu \
    # Glibc
    libc6-arm64-cross \
    libc6-armel-armhf-cross \
    libc6-armel-cross \
    libc6-armhf-cross \
    libc6-hppa-cross \
    libc6-i386-cross \
    libc6-m68k-cross \
    libc6-mips-cross \
    libc6-mipsel-cross \
    libc6-mips64-cross \
    libc6-mips64el-cross \
    libc6-mips64r6-cross \
    libc6-mips64r6el-cross \
    libc6-mipsn32-cross \
    libc6-mipsn32el-cross \
    libc6-mipsn32r6-cross \
    libc6-mipsn32r6el-cross \
    libc6-mipsr6-cross \
    libc6-mipsr6el-cross \
    libc6-powerpc-cross \
    libc6-dev-ppc64-cross \
    libc6-dev-ppc64el-cross \
    libc6-riscv64-cross \
    libc6-s390-s390x-cross \
    libc6-sh4-cross \
    libc6-sparc64-cross \
    libc6.1-alpha-cross \
    # General utilities
    cmake \
    git \
    ca-certificates \
    qemu-user \
    make

RUN mkdir -p /toolchains
