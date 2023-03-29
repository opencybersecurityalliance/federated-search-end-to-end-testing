#!/bin/bash

ES_PWD=$(cat "${HOME}"/huntingtest/.es_pwd)
mkdir -p data
cd data || exit
dataindexes=( "linux-91-sysflow-test-20220725" "win-111-winlogbeat-bh22-20220727" "win-111-winlogbeat-test-20220726" )
for dataindex in "${dataindexes[@]}" 
do
    wget https://media.githubusercontent.com/media/opencybersecurityalliance/data-bucket-kestrel/main/elasticsearch/"${dataindex}".json.gz
    echo "Downloaded ${dataindex}"
    gunzip -q "${dataindex}".json.gz
    echo "Unzipped ${dataindex}"
    sudo docker run --rm --net=host -e NODE_TLS_REJECT_UNAUTHORIZED=0 -v "${PWD}":/tmp elasticdump/elasticsearch-dump \
    --output=https://"elastic:${ES_PWD}"@localhost:9234/"${dataindex}" \
    --input=/tmp/"${dataindex}".json  --limit 25000  --type=data
    echo "Uploaded ${dataindex} in elasticsearch"
done
