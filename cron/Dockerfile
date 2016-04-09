FROM webwurst/go-cron

MAINTAINER jrrdev


WORKDIR /mantis-sync-cron/

COPY ./scripts/tasks.sh ./

RUN chmod +x ./tasks.sh && \
	sync

EXPOSE 18080
