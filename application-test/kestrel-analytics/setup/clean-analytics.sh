#!/bin/bash
ana_containers_string=$(sudo docker ps -a | grep kestrel-analytics-domainnamelookup | awk '{print $1}')
if [ -z "$ana_containers_string" ]
then
    echo "No analytics containers found, nothing to remove"
else
    mapfile -t ana_containers <<< "$ana_containers_string"
    for ana_container in "${ana_containers[@]}"
    do
        echo "Removing analytics container ${ana_container}"
        sudo docker stop "$ana_container"
        sudo docker rm "$ana_container"
    done
fi
ana_images_string=$(sudo docker images | grep kestrel-analytics-domainnamelookup | awk '{print $3}')
if [ -z "$ana_images_string" ]
then
    echo "No analytics images found, nothing to remove"
else
    mapfile -t ana_images <<< "$ana_images_string"
    for ana_image in "${ana_images[@]}"
    do
        echo "Removing analytics image ${ana_image}"
        sudo docker rmi "$ana_image"
    done
fi
