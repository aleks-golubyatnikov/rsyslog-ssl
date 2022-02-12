#!/bin/bash

export $(cat .env | egrep -v "(^#.*|^$)" | xargs)
find ./rsyslog/certificates/ -type f | grep -v cnf | xargs rm -rf

### 1: NO certificates
#CA:
openssl genrsa -out $CERT_PATH/ca.key 2048
openssl req -new -key $CERT_PATH/ca.key -subj "/CN=$CA_SERVER_LOCAL" -config $CERT_PATH/ca.cnf -out $CERT_PATH/ca.csr
openssl x509 -req -days 365 -in $CERT_PATH/ca.csr -signkey $CERT_PATH/ca.key -extensions req_ext -extfile $CERT_PATH/ca.cnf -outform PEM -out $CERT_PATH/ca.crt

#Convert:
openssl x509 -outform PEM -in $CERT_PATH/ca.crt -out $CERT_PATH/ca.crt.pem
openssl rsa -in $CERT_PATH/ca.key -text > $CERT_PATH/ca.key.pem

#Server:
openssl genrsa -out $CERT_PATH/$SERVER_LOCAL.key 2048
openssl req -new -key $CERT_PATH/$SERVER_LOCAL.key -subj "/CN=$SERVER_LOCAL" -config $CERT_PATH/server.cnf -out $CERT_PATH/$SERVER_LOCAL.csr
openssl x509 -req -days 365 -in $CERT_PATH/$SERVER_LOCAL.csr -CA $CERT_PATH/ca.crt.pem -CAkey $CERT_PATH/ca.key -CAcreateserial -extensions req_ext -extfile $CERT_PATH/server.cnf -out $CERT_PATH/$SERVER_LOCAL.crt

#Convert:
openssl x509 -outform PEM -in $CERT_PATH/$SERVER_LOCAL.crt -out $CERT_PATH/$SERVER_LOCAL.crt.pem
openssl rsa -in $CERT_PATH/$SERVER_LOCAL.key -text > $CERT_PATH/$SERVER_LOCAL.key.pem

#Client:
openssl genrsa -out $CERT_PATH/$CLIENT_LOCAL.key 2048
openssl req -new -key $CERT_PATH/$CLIENT_LOCAL.key -subj "/CN=$CLIENT_LOCAL" -config $CERT_PATH/client.cnf -out $CERT_PATH/$CLIENT_LOCAL.csr
openssl x509 -req -days 365 -in $CERT_PATH/$CLIENT_LOCAL.csr -CA $CERT_PATH/ca.crt.pem -CAkey $CERT_PATH/ca.key -CAcreateserial -extensions req_ext -extfile $CERT_PATH/client.cnf -out $CERT_PATH/$CLIENT_LOCAL.crt

#Convert:
openssl x509 -outform PEM -in $CERT_PATH/$CLIENT_LOCAL.crt -out $CERT_PATH/$CLIENT_LOCAL.crt.pem
openssl rsa -in $CERT_PATH/$CLIENT_LOCAL.key -text > $CERT_PATH/$CLIENT_LOCAL.key.pem