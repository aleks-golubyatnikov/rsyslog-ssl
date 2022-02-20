#!/bin/bash

sed -i "s|%SERVER_CA_FILE%|$CA_PATH|g" /etc/rsyslog.conf
sed -i "s|%SERVER_CERT_PATH%|$CERT_PATH|g" /etc/rsyslog.conf
sed -i "s|%SERVER_KEY_PATH%|$KEY_PATH|g" /etc/rsyslog.conf
sed -i "s|%SERVER_MAX_TCP_SESSIONS%|$MAX_TCP_SESSIONS|g" /etc/rsyslog.conf
sed -i "s|%SERVER_TLS_PORT%|$TLS_PORT|g" /etc/rsyslog.conf
sed -i "s|%SERVER_TEMPLATE_PATH%|$TEMPLATE_PATH|g" /etc/rsyslog.conf

rsyslogd -n -f /etc/rsyslog.conf
