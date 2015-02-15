FROM       debian:wheezy
MAINTAINER Fabian Stehle <fabi@fstehle.de>

ENV        DEBIAN_FRONTEND noninteractive
ENV        SKYLINE_COMMIT b5f90cad97fea2a7355b167d4e809bc2a166a356
ENV        DOTDEB_GPGKEY E9C74FEEA2098A6E
           
COPY       ./etc/apt/sources.list.d/dotdeb.list /etc/apt/sources.list.d/dotdeb.list
COPY       ./etc/apt/preferences.d/dotdeb /etc/apt/preferences.d/dotdeb

RUN        gpg --keyserver pgpkeys.mit.edu --recv-key $DOTDEB_GPGKEY && \
           gpg -a --export $DOTDEB_GPGKEY | apt-key add -
           
RUN        apt-get -y update && \
           apt-get -y upgrade && \
           apt-get -y dist-upgrade && \
           apt-get clean && apt-get purge
RUN        apt-get -y install build-essential && \
           apt-get clean && apt-get purge
RUN        apt-get -y install python python-dev python-scipy && \
           apt-get clean && apt-get purge
RUN        apt-get -y install python-pip && \
           apt-get clean && apt-get purge
RUN        apt-get -y install curl && \
           apt-get clean && apt-get purge
RUN        apt-get -y install redis-server && \
           apt-get clean && apt-get purge
RUN        apt-get -y install supervisor && \
           apt-get clean && apt-get purge

RUN        pip install numpy==1.9.1
RUN        pip install pandas==0.15.2 patsy==0.3.0
RUN        pip install statsmodels==0.6.1 msgpack-python==0.4.5
           
RUN        mkdir /skyline && \
           curl -q -L -O https://github.com/etsy/skyline/archive/$SKYLINE_COMMIT.tar.gz && \
					 tar -xzf $SKYLINE_COMMIT.tar.gz -C /skyline --strip-components=1 && \
					 rm $SKYLINE_COMMIT.tar.gz
RUN        cd /skyline && \
		       pip install -r requirements.txt
					 
RUN        mkdir -p /var/log/supervisor /var/log/skyline /var/run/skyline /var/log/redis /var/dump

COPY       ./etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY       ./etc/settings.py /skyline/src/settings.py

EXPOSE     1500
CMD        ["/usr/bin/supervisord"]


