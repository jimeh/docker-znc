# version 1.6.1-1
# docker-version 1.8.2
FROM ubuntu:15.10
MAINTAINER Jim Myhrberg "contact@jimeh.me"

ENV ZNC_VERSION 1.6.1

RUN apt-get update \
    && apt-get install -y sudo wget build-essential libssl-dev libperl-dev \
               pkg-config swig3.0 libicu-dev \
    && mkdir -p /src \
    && cd /src \
    && wget "http://znc.in/releases/archive/znc-${ZNC_VERSION}.tar.gz" \
    && tar -zxf "znc-${ZNC_VERSION}.tar.gz" \
    && cd "znc-${ZNC_VERSION}" \
    && ./configure \
    && make \
    && make install \
    && apt-get remove -y wget \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /src* /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd znc
ADD docker-entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default
RUN chmod 644 /znc.conf.default

VOLUME /znc-data

EXPOSE 6667
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
