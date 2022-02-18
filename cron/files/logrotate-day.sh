#!/bin/sh

for d in $(find /var/logs/agentlogs-tls/ -mindepth 1 -maxdepth 1 -type d)
do
    echo $d;
    for f in $(find $d -mindepth 1 -maxdepth 1 -type f)
    do
        echo $f;
    done
done

echo "Created file ... 15min" >> /var/log/agentlogs-tls/cron-15min.log




