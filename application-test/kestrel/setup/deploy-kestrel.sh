#!/bin/bash

echo "Adding elastic secrets to STIX-Shifter profiles in the Kestrel configuration file"
ES_PWD=$(cat "${HOME}"/fedsearchtest/.es_pwd)
cp application-test/kestrel/config/kestrel-stixshifter-config.yml "${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml
sed -i'' -e "s/<ES_PWD>/${ES_PWD}/" "${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml
echo "Checking Kestrel and Elasticsearch deployment ..."
if kestrel application-test/kestrel/test/huntflows/kestrel-test.hf; then
    echo "Successfully deployed Kestrel with Elasticsearch data store"
else
    echo "Failed to deploy Kestrel with Elasticsearch data store"
    exit 1
fi