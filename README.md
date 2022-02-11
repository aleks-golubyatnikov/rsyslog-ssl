### Certificates:
```
export CA_SERVER_LOCAL=internal.com
export SERVER_LOCAL=linux01.internal.com
export CERT_PATH=./rsyslog/certificates

#CA
openssl genrsa -out $CERT_PATH/ca.key 2048
openssl req -new -key $CERT_PATH/ca.key -subj "/CN=$CA_SERVER_LOCAL" -config $CERT_PATH/ca.cnf -out $CERT_PATH/ca.csr
openssl x509 -req -days 365 -in $CERT_PATH/ca.csr -signkey $CERT_PATH/ca.key -extensions req_ext -extfile $CERT_PATH/ca.cnf -outform PEM -out $CERT_PATH/ca.crt

#convert (if neaded)
openssl x509 -inform DER -outform PEM -in $CERT_PATH/ca.crt -out $CERT_PATH/ca.crt.pem

#server
openssl genrsa -out $CERT_PATH/$SERVER_LOCAL.key 2048
openssl req -new -key $CERT_PATH/$SERVER_LOCAL.key -subj "/CN=$SERVER_LOCAL" -config $CERT_PATH/server.cnf -out $CERT_PATH/$SERVER_LOCAL.csr
openssl x509 -req -days 365 -in $CERT_PATH/$SERVER_LOCAL.csr -CA $CERT_PATH/ca.crt -CAkey $CERT_PATH/ca.key -CAcreateserial -extensions req_ext -extfile $CERT_PATH/server.cnf -out $CERT_PATH/$SERVER_LOCAL.crt

#convert (if neaded)
openssl x509 -inform DER -outform PEM -in $CERT_PATH/$SERVER_LOCAL.crt -out $CERT_PATH/$SERVER_LOCAL.crt.pem
```

#Docker
#build image
docker build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/ --build-arg PATH_LOGS_INSIDE=/var/log/agentlogs-tls/ -t dev-syslog-tls .

#run
docker run -it --rm -h rsyslog-server.com --privileged --name rsyslog-tls dev-syslog-tls
docker run -it --rm -h rsyslog-server.com --cap-add SYSLOG --privileged -v /var/logs:/var/log -p 10514:10514 --name rsyslog-tls dev-syslog-tls
#background
docker run --restart always -d -h rsyslog-server.com --cap-add SYSLOG --privileged -v /var/logs:/var/log -p 10514:10514 --name rsyslog-tls dev-syslog-tls

#cert
#ca
#rsa private key
certtool --generate-privkey --outfile ca-key.pem

#generate-self-signed cert
generate-self-signed --load-privkey ca-key.pem --outfile ca.pem

#server
certtool --generate-privkey --outfile rsyslog-server-key.pem --bits 2048
certtool --generate-request --load-privkey rsyslog-server-key.pem --outfile request.pem
 - common name: rsyslog-server.com
 - Is this a TLS web client certificate? (y/N): y
 - Is this also a TLS web server certificate? (y/N): y

certtool --generate-certificate --load-request request.pem --outfile rsyslog-server-cert.pem --load-ca-certificate ca.pem --load-ca-privkey ca-key.pem
 - Enter a dnsName of the subject of the certificate: rsyslog-server.com
 - Is this a TLS web client certificate? (y/N): y
 - Is this also a TLS web server certificate? (y/N): y

#client
#the actions are the same as for the server

#Docker Compose
#build
docker-compose build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/ --build-arg PATH_LOGS_INSIDE=/var/log/agentlogs-tls/

#run
docker-compose up -d

#stop
docker-compose stop

#client config lines
$DefaultNetstreamDriver gtls

$DefaultNetstreamDriverCAFile /etc/pki/rsyslog/ca.pem
$DefaultNetstreamDriverCertFile /etc/pki/rsyslog/rsyslog-server-cert.pem
$DefaultNetstreamDriverKeyFile /etc/pki/rsyslog/rsyslog-server-key.pem

$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat

$ActionSendStreamDriverAuthMode x509/name
$ActionSendStreamDriverPermittedPeer rsyslog-server
$ActionSendStreamDriverMode 1

*.* @@rsyslog-server.com:10514