#!/bin/bash

export $(cat .env | egrep -v "(^#.*|^$)" | xargs)

sed -i "s/%%ca.pem%%/$CA_NAME/" $CONF_PATH/rsyslog.conf
sed -i "s/%%server-cert.pem%%/$SERVER_CRT_NAME/" $CONF_PATH/rsyslog.conf
sed -i "s/%%server-key.pem%%/$SERVER_KEY_NAME/" $CONF_PATH/rsyslog.conf
sed -i "s/%%_TLS_PORT_%%/$TLS_PORT_CONTAINER/" $CONF_PATH/rsyslog.conf