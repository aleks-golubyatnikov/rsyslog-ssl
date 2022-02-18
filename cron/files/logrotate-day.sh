#!/bin/sh

ROTATE_DAYS=1
DELETE_DAYS=30
PATH_FILES=/var/logs/agentlogs-tls/
PATH_LOG_FILE=/var/logs/agentlogs-tls/cron-day.log

for d in $(find $PATH_FILES -mindepth 1 -maxdepth 1 -type d)
do
    for f in $(find $d -mindepth 1 -maxdepth 2 -type f -name "*.log" -mtime +"$((ROTATE_DAYS - 1))" | sort)
    do
        echo "$(date '+%Y-%m-%d %H:%M:%S') Compressing '$f' ... " >> $PATH_LOG_FILE;
        if tar czfP "$f.$(date '+%Y_%m_%d_%H_%M').tar.gz" "$f"; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Done" >> $PATH_LOG_FILE;
            rm -rf "$f";
        else
            echo "Failed" >> $PATH_LOG_FILE;
        fi
    done
done

for d in $(find $PATH_FILES -mindepth 1 -maxdepth 1 -type d)
do
    for f in $(find $d -mindepth 1 -maxdepth 2 -type f -name "*.tar.gz" -mtime +"$((DELETE_DAYS - 1))" | sort)
    do
        echo "$(date '+%Y-%m-%d %H:%M:%S') Removing '$f' ... " >> $PATH_LOG_FILE;
        if rm -rf "$f"; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Done" >> $PATH_LOG_FILE;
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') Failed" >> $PATH_LOG_FILE;
        fi
    done
done