FROM alpine:3.7
MAINTAINER Davi Alves

RUN unlink /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN rm -rf /tmp/* /var/tmp/*

RUN adduser automation -D

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories && \
	echo "http://dl-4.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories

RUN apk update && \
	apk add python py-pip curl unzip libexif udev chromium chromium-chromedriver xvfb && \
	pip install selenium && \
	pip install pyvirtualdisplay

# Install Supervisor
RUN pip install supervisor

# Configure Supervisor
ADD ./etc/supervisord.conf /etc/
ADD ./etc/supervisor /etc/supervisor

# Default configuration
ENV DISPLAY :20.0
ENV SCREEN_GEOMETRY "1440x900x24"
ENV CHROMEDRIVER_PORT 4444
ENV CHROMEDRIVER_WHITELISTED_IPS "127.0.0.1"
ENV CHROMEDRIVER_URL_BASE ''

EXPOSE 4444

VOLUME [ "/var/log/supervisor" ]

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
