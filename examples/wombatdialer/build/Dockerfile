FROM lenz/whaleware:190913a

EXPOSE 8080


RUN yum install -y wget lsof nano tar jq && \
    yum install -y queuemetrics-tomcat && \
    yum install -y wombat

ADD ./ww /ww

