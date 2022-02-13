#!/bin/bash

export $(cat .env | egrep -v "(^#.*|^$)" | xargs)

#Client:
openssl genrsa -out $CERT_PATH/$CLIENT_LOCAL.key 2048
openssl req -new -key $CERT_PATH/$CLIENT_LOCAL.key -subj "/CN=$CLIENT_LOCAL" -config $CERT_PATH/client.cnf -out $CERT_PATH/$CLIENT_LOCAL.csr
openssl x509 -req -days 365 -in $CERT_PATH/$CLIENT_LOCAL.csr -CA $CERT_PATH/ca.crt.pem -CAkey $CERT_PATH/ca.key -CAcreateserial -extensions req_ext -extfile $CERT_PATH/client.cnf -out $CERT_PATH/$CLIENT_LOCAL.crt

#Convert:
openssl x509 -outform PEM -in $CERT_PATH/$CLIENT_LOCAL.crt -out $CERT_PATH/$CLIENT_LOCAL.crt.pem
openssl rsa -in $CERT_PATH/$CLIENT_LOCAL.key -text > $CERT_PATH/$CLIENT_LOCAL.key.pem