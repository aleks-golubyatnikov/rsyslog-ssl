ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION
COPY /cron/logrotate-day.sh /etc/periodic/15min/
COPY /cron/logrotate-month.sh /etc/periodic/monthly/

ENTRYPOINT ["crond","-f","-l","8"]
