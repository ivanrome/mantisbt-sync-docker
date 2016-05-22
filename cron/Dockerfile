FROM webwurst/go-cron

MAINTAINER jrrdev

ENV LOCAL_TIME_ZONE "Europe/Paris"

WORKDIR /mantis-sync-cron/

COPY ./scripts/tasks.sh ./

RUN chmod +x ./tasks.sh && \
	sync && \
	echo "http://dl-1.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories && \
	echo "http://dl-2.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories && \
	echo "http://dl-3.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories && \
	echo "http://dl-5.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories && \
	echo "http://alpine.gliderlabs.com/alpine/v3.2/main/" >> /etc/apk/repositories && \
	apk add -U tzdata && \
	rm -rf /var/cache/apk/* && \
	cp /usr/share/zoneinfo/$LOCAL_TIME_ZONE /etc/localtime

EXPOSE 18080
