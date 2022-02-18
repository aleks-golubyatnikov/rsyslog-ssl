ARG ALPINE_VERSION
ARG ROTATE_DAYS
ARG DELETE_DAYS

FROM alpine:$ALPINE_VERSION

ENV AGE_DAYS=$ROTATE_DAYS
ENV DEL_DAYS=$DELETE_DAYS

COPY files/logrotate-day.sh /etc/periodic/daily/

RUN chmod a+x /etc/periodic/daily/logrotate-day.sh

ENTRYPOINT ["crond","-f","-l","8"]