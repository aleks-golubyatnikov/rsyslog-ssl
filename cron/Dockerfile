ARG ALPINE_VERSION
ARG ROTATE_DAYS
ARG DELETE_DAYS

ENV ROTATE_DAYS=$ROTATE_DAYS
ENV DELETE_DAYS=$DELETE_DAYS

FROM alpine:$ALPINE_VERSION

COPY files/logrotate-day.sh /etc/periodic/daily/

RUN chmod a+x /etc/periodic/daily/logrotate-day.sh && \
    sed -i "s/ROTATE_DAYS=1/ROTATE_DAYS=$ROTATE_DAYS/" /etc/periodic/daily/logrotate-day.sh && \ 
    sed -i "s/DELETE_DAYS=30/DELETE_DAYS=$DELETE_DAYS/" /etc/periodic/daily/logrotate-day.sh

ENTRYPOINT ["crond","-f","-l","8"]