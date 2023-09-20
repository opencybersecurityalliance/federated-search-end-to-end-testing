#!/bin/bash

echo "Disable memory paging and swapping performance on the host to improve performance"
sudo swapoff -a
echo "Increase the number of memory maps available to OpenSearch"
sudo echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "Reload the kernel parameters using sysctl"
sudo sysctl -p
echo "Verify that the change was applied by checking the value of max_map_count"
cat /proc/sys/vm/max_map_count
echo "Deploying OpenSearch in a single container"
echo "Map ports 9200 and 9600, set the discovery type to \"single-node\" and requests the newest image of OpenSearch"
docker run -d --name os01test -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" opensearchproject/opensearch:latest

echo "Waiting for the OpenSearch server to come up"

SERVER_URL="https://www.example.com"

# Check the server URL using curl
while ! curl https://localhost:9200 -ku 'admin:admin' > /dev/null; do
  sleep 5
done

echo "OpenSearch server is up and running!"
