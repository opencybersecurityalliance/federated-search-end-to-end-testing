#!/bin/bash

pip install behave
ES_PWD=$(cat "${HOME}"/.es_pwd)
cp kestrel-stixshifter-config.yml "${HOME}"/kestrel-stixshifter-config.yaml
sed -i "s/<ES_PWD>/${ES_PWD}/" "${HOME}"/kestrel-stixshifter-config.yaml
export KESTREL_STIXSHIFTER_CONFIG=${HOME}/kestrel-stixshifter-config.yaml
behave --logging-level CRITICAL
