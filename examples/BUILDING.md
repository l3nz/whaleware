# How to build examples on a CentOS VM

Start a Vagrant VM

	yum install -y git docker-io
	service docker start

Clone  and choose a product.

	git  clone https://github.com/l3nz/whaleware.git
	cd whaleware/examples/queuemetrics/build

**Building**

	docker build -t=qm .

**Testing**

	docker run -p 8080:8080 -P -d qm

**Tagging and uploading**

I tag as `version:build`.

	docker tag qm loway/queuemetrics:19.10.1-715
	docker tag qm loway/queuemetrics:latest

Login:

	docker login 

	docker push loway/queuemetrics:19.10.1-715
	docker push loway/queuemetrics:latest


