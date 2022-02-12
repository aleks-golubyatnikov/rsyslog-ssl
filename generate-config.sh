#!/bin/bash

export $(cat .env | egrep -v "(^#.*|^$)" | xargs)

sed -i "s/%%ca.pem%%/ca.crt.pem/" $CONF_PATH/rsyslog.conf
sed -i "s/%%server-cert.pem%%/$SERVER_LOCAL.crt.pem/" $CONF_PATH/rsyslog.conf
sed -i "s/%%server-key.pem%%/$SERVER_LOCAL.key.pem/" $CONF_PATH/rsyslog.conf
sed -i "s/%%_TLS_PORT_%%/$TLS_PORT_CONTAINER/" $CONF_PATH/rsyslog.conf
