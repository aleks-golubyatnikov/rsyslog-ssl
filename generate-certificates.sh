#!/bin/bash

export $(cat .env | egrep -v "(^#.*|^$)" | xargs)
rm -rf $CERT_PATH/*.key
rm -rf $CERT_PATH/*.crt
rm -rf $CERT_PATH/*.csr
rm -rf $CERT_PATH/*.pem
rm -rf $CERT_PATH/*.srl

#ca
openssl genrsa -out $CERT_PATH/ca.key 2048
openssl req -new -key $CERT_PATH/ca.key -subj "/CN=$CA_SERVER_LOCAL" -config $CERT_PATH/ca.cnf -out $CERT_PATH/ca.csr
openssl x509 -req -days 365 -in $CERT_PATH/ca.csr -signkey $CERT_PATH/ca.key -extensions req_ext -extfile $CERT_PATH/ca.cnf -outform PEM -out $CERT_PATH/ca.crt

#convert (if neaded)
openssl x509 -outform PEM -in $CERT_PATH/ca.crt -out $CERT_PATH/ca.crt.pem
openssl rsa -in $CERT_PATH/ca.key -text > $CERT_PATH/ca.key.pem

#server
openssl genrsa -out $CERT_PATH/$SERVER_LOCAL.key 2048
openssl req -new -key $CERT_PATH/$SERVER_LOCAL.key -subj "/CN=$SERVER_LOCAL" -config $CERT_PATH/server.cnf -out $CERT_PATH/$SERVER_LOCAL.csr
openssl x509 -req -days 365 -in $CERT_PATH/$SERVER_LOCAL.csr -CA $CERT_PATH/ca.crt.pem -CAkey $CERT_PATH/ca.key -CAcreateserial -extensions req_ext -extfile $CERT_PATH/server.cnf -out $CERT_PATH/$SERVER_LOCAL.crt

#convert (if neaded)
openssl x509 -outform PEM -in $CERT_PATH/$SERVER_LOCAL.crt -out $CERT_PATH/$SERVER_LOCAL.crt.pem
openssl rsa -in $CERT_PATH/$SERVER_LOCAL.key -text > $CERT_PATH/$SERVER_LOCAL.key.pem

# client
openssl genrsa -out $CERT_PATH/$CLIENT_LOCAL.key 2048
openssl req -new -key $CERT_PATH/$CLIENT_LOCAL.key -subj "/CN=$CLIENT_LOCAL" -config $CERT_PATH/client.cnf -out $CERT_PATH/$CLIENT_LOCAL.csr
openssl x509 -req -days 365 -in $CERT_PATH/$CLIENT_LOCAL.csr -CA $CERT_PATH/ca.crt.pem -CAkey $CERT_PATH/ca.key -CAcreateserial -extensions req_ext -extfile $CERT_PATH/client.cnf -out $CERT_PATH/$CLIENT_LOCAL.crt

#convert (if neaded)
openssl x509 -outform PEM -in $CERT_PATH/$CLIENT_LOCAL.crt -out $CERT_PATH/$CLIENT_LOCAL.crt.pem
openssl rsa -in $CERT_PATH/$CLIENT_LOCAL.key -text > $CERT_PATH/$CLIENT_LOCAL.key.pem


#Config file (Docker)
sed -i "s/%%ca.pem%%/ca.crt.pem/" $CONF_PATH/rsyslog.conf
sed -i "s/%%server-cert.pem%%/$SERVER_LOCAL.crt.pem/" $CONF_PATH/rsyslog.conf
sed -i "s/%%server-key.pem%%/$SERVER_LOCAL.key.pem/" $CONF_PATH/rsyslog.conf
sed -i "s/%%_PATH_LOGS_%%/$LOG_CONT/" $CONF_PATH/rsyslog.conf

###