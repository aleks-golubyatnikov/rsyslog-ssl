FROM ubuntu:20.04

RUN apt-get update && apt-get install -y rsyslog rsyslog-gnutls gnutls-bin
RUN mv /etc/rsyslog.conf /etc/rsyslog.example

COPY /config/rsyslog.conf /etc/rsyslog

