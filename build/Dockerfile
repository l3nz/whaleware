FROM centos:centos6

RUN yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum install -y wget lsof nano tar jq && \
    yum update -y bash

RUN mkdir -p /data
RUN mkdir -p /ww
RUN mkdir -p /backup

CMD ["/ww/run"]
ADD ./ww /ww



