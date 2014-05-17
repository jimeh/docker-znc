#! /usr/bin/env bash
set -e


# Config
ZNC_VERSION="1.4"


# Install build dependencies.
apt-get update
apt-get install -y wget build-essential libssl-dev libperl-dev pkg-config


# Prepare building
mkdir -p /src


# Download, compile and install ZNC.
cd /src
wget "http://znc.in/releases/archive/znc-${ZNC_VERSION}.tar.gz"
tar -zxf "znc-${ZNC_VERSION}.tar.gz"
cd "znc-${ZNC_VERSION}"
./configure && make && make install


# Clean up
apt-get remove -y wget
apt-get autoremove -y
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
