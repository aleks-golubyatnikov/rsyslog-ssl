#!/bin/sh

ROTATE_DAYS=$AGE_DAYS
DELETE_DAYS=$DEL_DAYS
PATH_FILES=$APP_PATH_FILES
PATH_LOG_FILE=$APP_PATH_LOG_FILE
MAX_DEPTH_DIR=$DEPTH_DIR
MAX_DEPTH_FILES=$DEPTH_FILES

echo "$(date '+%Y-%m-%d %H:%M:%S') File rotation process started with options: [ROTATE_DAYS] => '$AGE_DAYS', [PATH_LOG_FILE] => '$APP_PATH_LOG_FILE' " >> $PATH_LOG_FILE;
for d in $(find $PATH_FILES -mindepth 1 -maxdepth $MAX_DEPTH_DIR -type d)
do
    echo $d
    for f in $(find $d -mindepth 1 -maxdepth $MAX_DEPTH_FILES -type f -name "*.log" -mtime +"$((ROTATE_DAYS - 1))" | sort)
    do
        echo "$(date '+%Y-%m-%d %H:%M:%S') Compressing '$f' ... " >> $PATH_LOG_FILE;
        if tar czf "$f.$(date '+%Y_%m_%d_%H_%M').tar.gz" "$f"; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Done" >> $PATH_LOG_FILE;
            rm -rf "$f";
        else
            echo "Failed" >> $PATH_LOG_FILE;
        fi
    done
done
echo "$(date '+%Y-%m-%d %H:%M:%S') File rotation process is finished" >> $PATH_LOG_FILE;

echo "$(date '+%Y-%m-%d %H:%M:%S') File deletion process started with options: [DELETE_DAYS] => '$DEL_DAYS', [PATH_LOG_FILE] => '$APP_PATH_LOG_FILE' " >> $PATH_LOG_FILE;
for d in $(find $PATH_FILES -mindepth 1 -maxdepth $MAX_DEPTH_DIR -type d)
do
    echo d$
    for f in $(find $d -mindepth 1 -maxdepth $MAX_DEPTH_FILES -type f -name "*.tar.gz" -mtime +"$((DELETE_DAYS - 1))" | sort)
    do
        echo "$(date '+%Y-%m-%d %H:%M:%S') Removing '$f' ... " >> $PATH_LOG_FILE;
        if rm -rf "$f"; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Done" >> $PATH_LOG_FILE;
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') Failed" >> $PATH_LOG_FILE;
        fi
    done
done
echo "$(date '+%Y-%m-%d %H:%M:%S') File deletion process is finished" >> $PATH_LOG_FILE;