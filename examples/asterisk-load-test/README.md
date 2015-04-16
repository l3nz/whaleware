# Pre-built Asterisk images for Asterisk ARI/AMI testing

Run multiple Asterisk instances on the same box. Run regression tests. Simulate clusters.
All on Docker.

This project was born as a simple way to do regression testing on [WombatDialer], 
our nice intelligent dialer that works with any existing Asterisk PBX. 

## Quick start

So you want to run an Asterisk 13 box and expose AMI on port 12345 of your host?

    docker run -p 12345:5038 -P -d lenz/asterisk-load-test-13

And you also want to run an Asterisk 1.8 and expose its AMI on port 12346 of the same box?

    docker run -p 12346:5038 -P -d lenz/asterisk-load-test-1.8

This makes it very easy to develop AMI / ARI applications.

Want to run WombatDialer to put some load on those images? 

     docker run -p 8080:8080 -P -d loway/wombatdialer

And connect to it over HTTP port 8080 (login as 'demoadmin' password 'demo').
See https://registry.hub.docker.com/u/loway/wombatdialer/


## Available Docker images

| Version       | AMI | ARI | Image         | Run with  | RPMS from |
| ------------- |:---:|:---:|:-------------:| --------- | --------- |
| Asterisk 1.8  | Yes | No  | [lenz/asterisk-load-test-1.8] | docker run -P -d lenz/asterisk-load-test-1.8 | CentOS |
| Asterisk 11   | Yes | No  | [lenz/asterisk-load-test-11]  | docker run -P -d lenz/asterisk-load-test-11 | Digium |
| Asterisk 12   | Yes | Yes | [lenz/asterisk-load-test-12]  | docker run -P -d lenz/asterisk-load-test-12 | Digium |
| Asterisk 13   | Yes | Yes | [lenz/asterisk-load-test-13]  | docker run -P -d lenz/asterisk-load-test-13 | Digium |


[lenz/asterisk-load-test-1.8]: https://registry.hub.docker.com/u/lenz/asterisk-load-test-1.8/
[lenz/asterisk-load-test-11]: https://registry.hub.docker.com/u/lenz/asterisk-load-test-11/
[lenz/asterisk-load-test-12]: https://registry.hub.docker.com/u/lenz/asterisk-load-test-12/
[lenz/asterisk-load-test-13]: https://registry.hub.docker.com/u/lenz/asterisk-load-test-13/
[WombatDialer]: http://wombatdialer.com
[Loway]: http://loway.ch
[QueueMetrics]: http://queuemetrics.com

Images here are built out of publicly-available RPMs.


# Using images

## Accounts

Access is allowed from any IP.

### AMI

Login: wombat / dials 

Login: admin / dials 


### ARI

Login: ari4java / yothere

## Sample dial plan

|  Extension        | What                       |
| :---------------: | -------------------------- |
|  any @ wdtrunk    | Waits between 1 and 5 seconds, then answers 70% of the calls with a length of 10-30 secs. All other calls are BUSY. |
|  any @ wdtkallanswered | Waits 1 second, andswers and waits 10 seconds before hanging up. |
|  100 @ wdep       | Answers and plays MOH indefinitely. |
|  20XXX @ wdep    |  Fake agent. Answers in 1 to 5 seconds and keeps the call up for 100 to 200 seconds. |
|  30XXX @ wdep    | Fake short agent. Answers in 1 second and keeps the call up for 15 seconds. |
|  301 @ wdep       | Routes calls to queue q1 |
|  302 @ wdep       | Routes calls to queue q2 |
|  100 @ wdivr      | Plays back "" and at the end of the file sets the WombatDialer's EXTSTATUS to 123. |


## Customizing




# Building

Copy the appropriate Dockerfile into build/

     docker build -tag=ast11 .
     docker run -p 2000:5038 a11

will add port 5038 (AMI) as port 2000

Running

     docker run -p 2010:5038 -P -d lenz/asterisk-load-test-13



# Testing AMI

Note where your AMI port is:

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

Note where your ARI port is.

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



