ARG ALPINE_VERSION
ARG ROTATE_DAYS
ARG DELETE_DAYS
ARG PATH_FILES
ARG PATH_LOG_FILE

FROM alpine:$ALPINE_VERSION

ENV AGE_DAYS=$ROTATE_DAYS
ENV DEL_DAYS=$DELETE_DAYS
ENV APP_PATH_FILES=$PATH_FILES
ENV APP_PATH_LOG_FILE=$PATH_LOG_FILE

COPY files/logrotate-day.sh /etc/periodic/daily/

RUN apk update && apk add nano && chmod a+x /etc/periodic/daily/logrotate-day.sh

ENTRYPOINT ["crond","-f","-l","8"]