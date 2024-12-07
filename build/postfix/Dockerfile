FROM ubuntu:22.04
MAINTAINER Felix Ratzkowski <felix@ratzkowski.com>, Lukas Voegtle <voegtlel@tf.uni-freiburg.de>

#RUN apk update && apk -U upgrade && \
#    apk add postfix bash vim && \
#    rm -rf /var/cache/apk/* /tmp/*
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install postfix mailutils vim syslog-ng syslog-ng-core -y && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    sed -i 's/system();/unix-dgram("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf

EXPOSE 25

ADD startup.sh /usr/bin/startup.sh
RUN chmod 755 /usr/bin/startup.sh

CMD ["/usr/bin/startup.sh"]

