FROM ubuntu:20.04

ARG PATH_CONFIG
ARG PATH_CERT

RUN apt-get update && apt-get install -y rsyslog rsyslog-gnutls gnutls-bin
RUN mv /etc/rsyslog.conf /etc/rsyslog.example

COPY $PATH_CONFIG/rsyslog.conf /etc/rsyslog.conf
COPY $PATH_CERT/ /etc/pki/rsyslog/

ENTRYPOINT ["rsyslogd", "-n"]
