# version 0.0.1
# docker-version 0.6.1
from        ubuntu:12.04
maintainer  Jim Myhrberg "contact@jimeh.me"

# Make sure the package repository is up to date.
run     echo "deb http://archive.ubuntu.com/ubuntu precise-backports universe" >> /etc/apt/sources.list
run     apt-get update


# Let's do this...
run     apt-get install -y znc/precise-backports znc-dbg/precise-backports znc-dev/precise-backports znc-extra/precise-backports znc-perl/precise-backports znc-python/precise-backports znc-tcl/precise-backports && apt-get clean

run     useradd znc
add     start-znc /usr/local/bin/
add     znc.conf.default /src/

user       znc
expose     6667
entrypoint ["/usr/local/bin/start-znc"]
cmd        [""]
