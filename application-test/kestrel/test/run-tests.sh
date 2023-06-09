#!/bin/bash
pip install behave
CRT_DIR="${PWD}"
if [ ! -f "${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml ]; then
    ES_PWD=$(cat "${HOME}"/fedsearchtest/.es_pwd)
    cp config/kestrel-stixshifter-config.yml "${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml
    sed -i'' -e "s/<ES_PWD>/${ES_PWD}/" "${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml
fi
export KESTREL_STIXSHIFTER_CONFIG="${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml
cd application-test/kestrel/test || exit
behave --logging-level CRITICAL
cd "${CRT_DIR}" || exit
