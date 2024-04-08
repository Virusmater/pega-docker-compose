#!/bin/bash
# get hostname, tier and start
cd "$(dirname "$0")"
PEGA_HOST=$(cat /etc/hostname)
export PEGA_HOST
if [[ $PEGA_HOST == *"-cdh" ]]; then
    export PEGA_TIER=cdh
    export PEGA_TYPE=ADM,Batch,RealTime,RTDG,Search,BackgroundProcessing
    export CASSANDRA_CLUSTER=true
    export CASSANDRA_NODES=cassandra
    docker compose --profile cdh up -d 
else
    docker compose up -d
fi
