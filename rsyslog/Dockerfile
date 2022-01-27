FROM ubuntu:20.04

ARG PATH_CONGIG
ARG PATH_CERT

RUN apt-get update && apt-get install -y rsyslog rsyslog-gnutls gnutls-bin
RUN mv /etc/rsyslog.conf /etc/rsyslog.example

COPY $PATH_CONGIG/rsyslog.conf /etc/rsyslog

