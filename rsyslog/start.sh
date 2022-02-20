#!/bin/bash

sed -i "s/%SERVER_CA_FILE%/$CA_PATH/" /etc/rsyslog.conf
sed -i "s/%SERVER_CERT_PATH%/$CERT_PATH/" /etc/rsyslog.conf
sed -i "s/%SERVER_KEY_PATH%/$KEY_PATH/" /etc/rsyslog.conf
sed -i "s/%SERVER_MAX_TCP_SESSIONS%/$MAX_TCP_SESSIONS/" /etc/rsyslog.conf
sed -i "s/%SERVER_TLS_PORT%/$TLS_PORT/" /etc/rsyslog.conf
sed -i "s/%SERVER_TEMPLATE_PATH%/$TEMPLATE_PATH/" /etc/rsyslog.conf

rsyslogd -n -f /etc/rsyslog.conf
