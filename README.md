## 1: NO certificates:
The variable file <.env> must be modified depending on the environment (#CA, #Server, #General blocks)

### Generate certificates:
```
chmod u+x ./generate-certificates.sh ./generate-config.sh
./generate-certificates.sh
```

### Change Docker configuration:
```
./generate-config.sh
```

### Copy certificates to local folder (in case of using VOLUME '/etc/pki/rsyslog/'):
```
/etc/pki/rsyslog-docker/ #on HOST machine
```

### Docker:
```
docker container stop $CONTAINER_NAME 
docker build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/ -t $IMAGE_NAME .

#run
docker run -it --rm -h $SERVER_LOCAL --privileged --name $CONTAINER_NAME dev-syslog-tls
docker run -it --rm -h $SERVER_LOCAL --cap-add SYSLOG --privileged -v /var/logs:/var/log -p $TLS_PORT_HOST:$TLS_PORT_CONTAINER --name $CONTAINER_NAME $IMAGE_NAME

#run in background
docker run --restart always -d -h $SERVER_LOCAL --cap-add SYSLOG --privileged -v /var/logs:/var/log -p $TLS_PORT_HOST:$TLS_PORT_CONTAINER --name $CONTAINER_NAME $IMAGE_NAME

```
### Docker Compose: 
```
docker-compose build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/
docker-compose up -d #background
docker-compose stop
```

## 2: Using existing certificates:
The variable file <.env> must be modified depending on the environment (#CA, #Server, #General blocks, #Existing certificates)

### Load ENV
```
export $(cat .env | egrep -v "(^#.*|^$)" | xargs)
```
### Copy certificates:
Certificates (CA.pem, certificate and server key) must be copied to the directory '.\rsyslog-ssl\rsyslog\certificates'

### Change Docker configuration:
```
./generate-config-exists-crt.sh
```
### Copy certificates to local folder (in case of using VOLUME '/etc/pki/rsyslog/'):
```
/etc/pki/rsyslog-docker/ #on HOST machine
```

### Docker:
```
docker container stop $CONTAINER_NAME 
docker build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/ -t $IMAGE_NAME .

#run
docker run -it --rm -h $SERVER_LOCAL --privileged --name $CONTAINER_NAME dev-syslog-tls
docker run -it --rm -h $SERVER_LOCAL --cap-add SYSLOG --privileged -v /var/logs:/var/log -p $TLS_PORT_HOST:$TLS_PORT_CONTAINER --name $CONTAINER_NAME $IMAGE_NAME

#run in background
docker run --restart always -d -h $SERVER_LOCAL --cap-add SYSLOG --privileged -v /var/logs:/var/log -p $TLS_PORT_HOST:$TLS_PORT_CONTAINER --name $CONTAINER_NAME $IMAGE_NAME

```
### Docker Compose: 
```
docker-compose build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/
docker-compose up -d #background
docker-compose stop
```



























### Export VARS
```
export $(cat .env | egrep -v "(^#.*|^$)" | xargs)
```

### Delete old containers (if exists):
```
docker container stop rsyslog-tls
```

### Docker:
```
docker build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/ -t $IMAGE_NAME .

#run
docker run -it --rm -h $SERVER_LOCAL --privileged --name $CONTAINER_NAME dev-syslog-tls
docker run -it --rm -h $SERVER_LOCAL --cap-add SYSLOG --privileged -v /var/logs:/var/log -p 10514:10514 --name $CONTAINER_NAME $IMAGE_NAME

#background
docker run --restart always -d -h $SERVER_LOCAL --cap-add SYSLOG --privileged -v /var/logs:/var/log -p 10514:10514 --name $CONTAINER_NAME $IMAGE_NAME

```
### Docker Compose: 
```
docker-compose build --build-arg PATH_CONFIG=/config/ --build-arg PATH_CERT=/certificates/
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

