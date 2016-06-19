FROM lenz/whaleware

EXPOSE 8080

RUN yum install -y wget lsof nano tar jq mysql && \
    wget -P /etc/yum.repos.d http://yum.loway.ch/loway.repo && \
    yum install -y queuemetrics-tomcat mysql-connectorj-java mysql mysql-server && \
    yum install -y queuemetrics

ADD ./ww /ww

