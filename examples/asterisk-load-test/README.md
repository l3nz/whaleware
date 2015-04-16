# Asterisk images for testing

Available Docker images:

| Version       | Image         | Start with  |
| ------------- |:-------------:| -----:|
| Asterisk 1.8  | lenz/asterisk-load-test-1.8 | docker run -P -d lenz/asterisk-load-test-1.8 |
| Asterisk 11   | lenz/asterisk-load-test-11  | docker run -P -d lenz/asterisk-load-test-11 |
| Asterisk 12   | lenz/asterisk-load-test-12  | docker run -P -d lenz/asterisk-load-test-12 |
| Asterisk 13   | lenz/asterisk-load-test-13  | docker run -P -d lenz/asterisk-load-test-13 |



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

Copy the appropriate Dockerfile into build/


docker build -tag=ast11 .
docker run -p 2000:5038 a11

will add port 5038 (AMI) as port 2000

Running

docker run -p 2010:5038 -P -d lenz/asterisk-load-test-13

# Testing AMI

telnet 127.0.0.1 2000

[root@localhost ~]# telnet 127.0.0.1 2004
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
Asterisk Call Manager/1.1
Action: logoff

Response: Goodbye
Message: Thanks for all the fish.

Connection closed by foreign host.

# Testing ARI (for Asterisk 12 and 13)


curl -u ari4java:yothere -X GET "http://localhost:49156/ari/asterisk/info"

# Accessing the container

Running a shell:

docker exec -it 52af95db1e52 /bin/bash
docker exec -it 52af95db1e52 /usr/sbin/asterisk -r

or just to run a command:

docker exec 52af95db1e52 /usr/sbin/asterisk -rx reload


# Open files issue

ulimit issue:

http://stackoverflow.com/questions/24318543/how-to-set-ulimit-file-descriptor-on-docker-container-the-image-tag-is-phusion



