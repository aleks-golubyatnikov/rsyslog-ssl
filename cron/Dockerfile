ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION

COPY files/logrotate-day.sh /etc/periodic/daily/

RUN chmod a+x /etc/periodic/daily/logrotate-day.sh 

ENTRYPOINT ["crond","-f","-l","8"]
