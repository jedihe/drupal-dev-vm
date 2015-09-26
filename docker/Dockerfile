FROM jedihe/baseimage-i386:precise
MAINTAINER jedihe <jedihe@gmail.com>

ENV HOME /root
RUN mkdir /build
ADD . /build

RUN /build/provision.sh && \
  cp /build/99_mysql_setup.sh /etc/my_init.d/99_mysql_setup.sh && \
  mkdir /etc/service/apache && cp /build/apache.sh /etc/service/apache/run && \
  mkdir /etc/service/mysql && cp /build/mysql.sh /etc/service/mysql/run

CMD ["/sbin/my_init"]

