#ARG PATH_CERT
ARG MAX_SESSIONS
ARG TLS_PORT_CONTAINER
ARG SERVER_CA_PATH
ARG SERVER_CERT_PATH
ARG SERVER_KEY_PATH
ARG SERVER_TEMPLATE_PATH

FROM ubuntu:20.04

ENV MAX_TCP_SESSIONS=$MAX_SESSIONS
ENV TLS_PORT=$TLS_PORT_CONTAINER
ENV CA_PATH=$SERVER_CA_PATH
ENV CERT_PATH=$SERVER_CERT_PATH
ENV KEY_PATH=$SERVER_KEY_PATH
ENV TEMPLATE_PATH=$SERVER_TEMPLATE_PATH

RUN apt-get update && apt-get install -y rsyslog rsyslog-gnutls gnutls-bin nano
RUN mv /etc/rsyslog.conf /etc/rsyslog.example

COPY config/rsyslog.conf /etc/rsyslog/rsyslog.conf
#COPY $PATH_CERT/ /etc/rsyslog/pki/

ENTRYPOINT ["rsyslogd", "-n", "-f",  "/etc/rsyslog/rsyslog.conf"]