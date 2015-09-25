FROM jedihe/baseimage-i386:precise
MAINTAINER jedihe <jedihe@gmail.com>

ENV HOME /root
RUN mkdir /build
ADD . /build

RUN /build/provision.sh

CMD ["/sbin/my_init"]

