
My own building steps

- open CentOS 7 VM
- Create image


		yum install -y git docker-io
		service docker start
		git clone https://github.com/l3nz/whaleware.git
		cd whaleware
		./createImage.sh


Testing

		docker run -it whaleware /bin/bash

		java -version



Pushing

docker tag whaleware lenz/whaleware:200630a
docker tag whaleware lenz/whaleware:latest




docker login
docker push lenz/whaleware:200630a
docker push lenz/whaleware:latest





/sbin/ldconfig: Cannot lstat /lib64/libbfd-2.27-43.base.el7.so: No such file or directory
/sbin/ldconfig: Cannot lstat /lib64/libopcodes-2.27-43.base.el7.so: No such file or directory
  Installing : mesa-libEGL-18.3.4-7.el7_8.1.x86_64                      108/127
/sbin/ldconfig: Cannot lstat /lib64/libbfd-2.27-43.base.el7.so: No such file or directory
/sbin/ldconfig: Cannot lstat /lib64/libopcodes-2.27-43.base.el7.so: No such file or directory
  Installing : 1:libglvnd-egl-1.0.1-0.8.git5baa1e5.el7.x86_64           109/127
/sbin/ldconfig: Cannot lstat /lib64/libbfd-2.27-43.base.el7.so: No such file or directory
/sbin/ldconfig: Cannot lstat /lib64/libopcodes-2.27-43.base.el7.so: No such file or directory
  Installing : cairo-1.15.12-4.el7.x86_64                               110/127
/sbin/ldconfig: Cannot lstat /lib64/libbfd-2.27-43.base.el7.so: No such file or directory
/sbin/ldconfig: Cannot lstat /lib64/libopcodes-2.27-43.base.el7.so: No such file or directory
  Installing : pango-1.42.4-4.el7_7.x86_64                              111/127
/sbin/ldconfig: Cannot lstat /lib64/libbfd-2.27-43.base.el7.so: No such file or directory
/sbin/ldconfig: Cannot lstat /lib64/libopcodes-2.27-43.base.el7.so: No such file or directory
  Installing : gtk2-2.24.31-1.el7.x86_64                                112/127
/sbin/ldconfig: Cannot lstat /lib64/libbfd-2.27-43.base.el7.so: No such file or directory

