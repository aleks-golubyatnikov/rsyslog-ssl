ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION

COPY files/logrotate-day.sh /etc/periodic/15min/
COPY files/logrotate-month.sh /etc/periodic/monthly/

RUN chmod a+x /etc/periodic/15min/*.sh && chmod a+x /etc/periodic/monthly/*.sh 

ENTRYPOINT ["crond","-f","-l","8"]
