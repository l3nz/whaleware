# https://rt-wiki.bestpractical.com/wiki/CentOS7Install
# https://github.com/okfn/docker-rt/blob/master/Dockerfile

FROM lenz/whaleware

EXPOSE 80

RUN yum install -y wget lsof nano tar jq mysql && \
    wget -P /etc/yum.repos.d http://yum.loway.ch/loway.repo

RUN yum install -y tzdata expat gd graphviz mysql-server mysql-devel openssl expat-devel gd-devel graphviz-devel mariadb-devel openssl-devel perl perl-CPAN wget screen mod_fcgid which
RUN yum groupinstall -y "Development Tools" "Web Server"

RUN curl -L http://cpanmin.us | perl - App::cpanminus

ENV RTVER 4.0.4


RUN mkdir -p /opt
RUN wget https://download.bestpractical.com/pub/rt/release/rt-${RTVER}.tar.gz
RUN tar xvzf rt-${RTVER}.tar.gz -C /opt
WORKDIR /opt/rt-${RTVER}
RUN ./configure --enable-graphviz --enable-gd --with-web-user=apache --with-web-group=apache

RUN cpanm XSLoader --force
RUN cpanm GnuPG::Interface
RUN cpanm Plack
RUN cpanm GD --force

RUN RT_FIX_DEPS_CMD=/usr/local/bin/cpanm      make fixdeps
RUN make testdeps
RUN make install


