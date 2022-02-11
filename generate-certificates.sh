#!/bin/bash

export $(cat .env | egrep -v "(^#.*|^$)" | xargs)

#CA
openssl genrsa -out $CERT_PATH/ca.key 2048
openssl req -new -key $CERT_PATH/ca.key -subj "/CN=$CA_SERVER_LOCAL" -config $CERT_PATH/ca.cnf -out $CERT_PATH/ca.csr
openssl x509 -req -days 365 -in $CERT_PATH/ca.csr -signkey $CERT_PATH/ca.key -extensions req_ext -extfile $CERT_PATH/ca.cnf -outform PEM -out $CERT_PATH/ca.crt

#convert (if neaded)
openssl x509 -outform PEM -in $CERT_PATH/ca.crt -out $CERT_PATH/ca.crt.pem

#server
openssl genrsa -out $CERT_PATH/$SERVER_LOCAL.key 2048
openssl req -new -key $CERT_PATH/$SERVER_LOCAL.key -subj "/CN=$SERVER_LOCAL" -config $CERT_PATH/server.cnf -out $CERT_PATH/$SERVER_LOCAL.csr
openssl x509 -req -days 365 -in $CERT_PATH/$SERVER_LOCAL.csr -CA $CERT_PATH/ca.crt.pem -CAkey $CERT_PATH/ca.key -CAcreateserial -extensions req_ext -extfile $CERT_PATH/server.cnf -out $CERT_PATH/$SERVER_LOCAL.crt

#convert (if neaded)
openssl x509 -outform PEM -in $CERT_PATH/$SERVER_LOCAL.crt -out $CERT_PATH/$SERVER_LOCAL.crt.pem
