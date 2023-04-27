#!/bin/bash
ana_containers=$(sudo docker ps -a | grep kestrel-analytics-domainnamelookup | awk '{print $1}')
for ana_container in "${ana_containers[@]}"
do
    sudo docker stop "$ana_container"
    sudo docker rm "$ana_container"
done
sudo docker rmi kestrel-analytics-domainnamelookup