FROM centos:centos7

RUN yum update -y && \
    yum install epel-release -y && \
    curl -s -q http://yum.loway.ch/loway.repo --output /etc/yum.repos.d/loway.repo && \
    yum install -y \
	bzip2 \
	initscripts \
	java-1.8.0-openjdk-devel \
	jq \
	less \
	lsof \
	mariadb-server \
	nano \
	net-tools \
	tar \
	wget && \
    yum clean all && \
    mkdir -p /data /ww /backup

EXPOSE 8080

CMD ["/ww/run"]

ADD ./ww /ww
ADD ./mysqld /etc/init.d/

