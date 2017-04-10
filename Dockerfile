#docker build --rm -t 
#docker run -it -p 6080:6080 vnctest2/vnc:v1
#browse: http://localhost:6080/vnc.html or http://localhost:6080/vnc_auto.html
FROM ubuntu:14.04

MAINTAINER bearpei <bearpei@hotmail.com>

#設定環境變數
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# setup our Ubuntu sources (ADD breaks caching)
RUN echo "deb http://gb.archive.ubuntu.com/ubuntu/ trusty main\n\
deb http://gb.archive.ubuntu.com/ubuntu/ trusty multiverse\n\
deb http://gb.archive.ubuntu.com/ubuntu/ trusty universe\n\
deb http://gb.archive.ubuntu.com/ubuntu/ trusty restricted\n\
deb http://security.ubuntu.com/ubuntu trusty-security main restricted\n\
deb http://security.ubuntu.com/ubuntu trusty-security universe\n\
deb http://security.ubuntu.com/ubuntu trusty-security multiverse\n\
"> /etc/apt/sources.list

#ADD start.sh /root/start.sh

# no Upstart or DBus
# https://github.com/dotcloud/docker/issues/1724#issuecomment-26294856
RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

#安裝軟體
RUN apt-get update -y &&\
     	 #apt-get install -y net-tools \
    	#supervisor \
	apt-get install -y --force-yes --no-install-recommends supervisor \
        net-tools \
	openssh-server \
  	pwgen sudo vim-tiny \
	wget \
	websockify \
	lxde xvfb x11vnc \
	git &&\
	mkdir -p /app &&\
    	apt-get clean &&\
    	rm -rf /var/lib/apt/lists/*

#git Clone noVNC from github
RUN cd / && git clone git://github.com/kanaka/noVNC

#ADD get_ssh_key.sh /get_ssh_key.sh
#RUN chmod 755 /get_ssh_key.sh
#RUN ./get_ssh_key.sh

ADD start.sh /root/start.sh
#copy supervisord 設定檔到容器裡
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#開的Port
EXPOSE 6080 5900 22
#EXPOSE 6080
#EXPOSE 5900
#EXPOSE 22

#設定對主機分享的資料夾
VOLUME ["/app/"]

WORKDIR /app

#執行時需要Run的指令
CMD ["sh", "/root/start.sh"]
