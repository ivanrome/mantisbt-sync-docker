FROM java:7-jre-alpine

MAINTAINER jrrdev

WORKDIR /mantis-sync-core-batch/

COPY ./entry-point.sh ./

RUN apk add -U wget tar ca-certificates && \
	rm -rf /var/cache/apk/*


ENV MANTIS_SYNC_CORE_VERSION 1.0.1-RELEASE

RUN chmod +x ./entry-point.sh && \
	sync && \
	mkdir -p /shared/data && \
	wget -nv --show-progress=on --progress=bar:force https://github.com/jrrdev/mantisbt-sync-core/releases/download/$MANTIS_SYNC_CORE_VERSION/mantisbt-sync-core-$MANTIS_SYNC_CORE_VERSION.tar.gz && \
	tar xzf mantisbt-sync-core-$MANTIS_SYNC_CORE_VERSION.tar.gz && \
	rm mantisbt-sync-core-$MANTIS_SYNC_CORE_VERSION.tar.gz

ENV SPRING_PROFILES_ACTIVE prod

ENTRYPOINT ["./entry-point.sh"]

EXPOSE 8080

VOLUME ["/shared/data"]


