#!/bin/bash
opensearch_containers_string=$(sudo docker ps -a | grep os01test | awk '{print $1}')
[ -z "$opensearch_containers_string" ] && exit 0
mapfile -t opensearch_containers <<< "$opensearch_containers_string"
for opensearch_container in "${opensearch_containers[@]}"
do
    echo "Removing opensearchsearch container ${opensearch_container}"
    sudo docker stop "$opensearch_container"
    sudo docker rm "$opensearch_container"
done
