#! /usr/bin/env bash

# Install
apt-get install -y python-software-properties
add-apt-repository ppa:teward/znc
apt-get update
apt-get install -y znc znc-dbg znc-dev znc-perl znc-python znc-tcl
apt-get install -y znc znc-dbg znc-dev znc-extra znc-perl znc-python znc-tcl


# Clean up
apt-get remove -y python-software-properties
apt-get autoremove -y
apt-get clean
