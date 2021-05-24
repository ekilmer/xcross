FROM ubuntu:20.04

RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install --assume-yes --no-install-recommends \
    cmake \
    git \
    ca-certificates \
    qemu-user \
    make

RUN mkdir -p /toolchains
