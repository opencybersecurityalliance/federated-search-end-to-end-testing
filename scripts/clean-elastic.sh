#!/bin/bash
elastic_containers_string=$(sudo docker ps -a | grep es01test | awk '{print $1}')
[ -z "$elastic_containers_string" ] && exit 0
mapfile -t elastic_containers <<< "$elastic_containers_string"
for elastic_container in "${elastic_containers[@]}"
do
    echo "Removing elasticsearch container ${elastic_container}"
    sudo docker stop "$elastic_container"
    sudo docker rm "$elastic_container"
done