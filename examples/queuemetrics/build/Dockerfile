FROM lenz/whaleware:200630a

EXPOSE 8080

RUN yum install -y wget lsof nano tar jq  && \
    wget -P /etc/yum.repos.d http://yum.loway.ch/loway.repo && \
    yum install -y queuemetrics

ADD ./ww /ww

