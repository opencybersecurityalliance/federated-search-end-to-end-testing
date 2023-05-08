#!/bin/bash

pip install behave
ES_PWD=$(cat "${HOME}"/huntingtest/.es_pwd)
cp config/kestrel-stixshifter-config.yml "${HOME}"/huntingtest/kestrel-stixshifter-config.yaml
sed -i'' -e "s/<ES_PWD>/${ES_PWD}/" "${HOME}"/huntingtest/kestrel-stixshifter-config.yaml
export KESTREL_STIXSHIFTER_CONFIG="${HOME}"/huntingtest/kestrel-stixshifter-config.yaml
CRT_DIR=${PWD}
cd "${HOME}"/huntingtest/kestrel-analytics/analytics/domainnamelookup || exit
sudo docker build -t kestrel-analytics-domainnamelookup .
cd "${CRT_DIR}" || exit