#!/bin/bash


# Start tomcat service
catalina.sh run &

# Wait tomcat startup done
date +"%F %T Waiting for tomcat startup..."
while [ "`curl --silent --write-out '%{response_code}' -o /dev/null 'http://localhost:8080/'`" == "000" ]; do
    sleep 1;
done
date +"%F %T Startup finished"

# Hack
/scripts/hack.sh

# Loop and Index if need
while true;
do
    if [ ! -f "/data/.index_done" ]; then
        # Index
        /scripts/index.sh
        # make a mark file
        touch /data/.index_done
        # Hack
        /scripts/hack.sh
    fi
    sleep 10
done
