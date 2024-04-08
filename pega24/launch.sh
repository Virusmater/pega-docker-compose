#!/bin/bash
# get hostname, tier and start
cd "$(dirname "$0")"
PEGA_HOST=$(cat /etc/hostname)
if [[ $PEGA_HOST == *"-cdh" ]]; then
    PEGA_TIER=cdh
    PEGA_TYPE=ADM,Batch,RealTime,RTDG,Search,BackgroundProcessing
    CASSANDRA_CLUSTER=true
    CASSANDRA_NODES=cassandra
    docker compose --profile cdh up -d 
else
    docker compose up -d
fi
