### Certificates:
```
chmod u+x ./generate-certificates.sh
./generate-certificates.sh
ls -la ./rsyslog/certificates/
```
### Export VARS
```
export $(cat .env | egrep -v "(^#.*|^$)" | xargs
```

### Docker:
```
docker build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/ --build-arg PATH_LOGS_INSIDE=/var/log/agentlogs-tls/ -t $IMAGE_NAME .

#run
docker run -it --rm -h $SERVER_LOCAL --privileged --name $CONTAINER_NAME dev-syslog-tls
docker run -it --rm -h $SERVER_LOCAL --cap-add SYSLOG --privileged -v /var/logs:/var/log -p 10514:10514 --name $CONTAINER_NAME $IMAGE_NAME

#background
docker run --restart always -d -h $SERVER_LOCAL --cap-add SYSLOG --privileged -v /var/logs:/var/log -p 10514:10514 --name $CONTAINER_NAME $IMAGE_NAME

```
### Docker Compose: 
```
docker-compose build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/ --build-arg PATH_LOGS_INSIDE=/var/log/agentlogs-tls/
docker-compose up -d
docker-compose stop
```
### Client:

#The actions are the same as for the server

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

### Cert tool (optional):

#CA
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

