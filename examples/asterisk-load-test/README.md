# Asterisk images for testing

Available Docker images:

Asterisk 13 (with ARI):

https://registry.hub.docker.com/u/lenz/asterisk-load-test-13/

Asterisk 11:

https://registry.hub.docker.com/u/lenz/asterisk-load-test-11/

Asterisk 1.8:

https://registry.hub.docker.com/u/lenz/asterisk-load-test-1.8/

# Accounts

AMI:  wombat/dials and admin/dials (from any IP)
ARI:  ari4java/yothere


# Building

docker build -tag=ast11 .


docker run -p 5036:5036 a11

# Available images

### Asterisk 1.8 (CentOS)
RUN yum install -y asterisk asterisk-configs

### Asterisk 11 (Digium)
RUN yum install -y asterisk asterisk-configs --enablerepo=asterisk-11

### Asterisk 13 (Digium)
RUN yum install -y asterisk asterisk-configs --enablerepo=asterisk-current



# Open files issue

ulimit issue:

http://stackoverflow.com/questions/24318543/how-to-set-ulimit-file-descriptor-on-docker-container-the-image-tag-is-phusion



