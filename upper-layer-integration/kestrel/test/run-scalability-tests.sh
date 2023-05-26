#!/bin/bash
if [ ! -f "${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml ]; then
    ES_PWD=$(cat "${HOME}"/fedsearchtest/.es_pwd)
    cp config/kestrel-stixshifter-config.yml "${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml
    sed -i'' -e "s/<ES_PWD>/${ES_PWD}/" "${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml
fi
export KESTREL_STIXSHIFTER_CONFIG="${HOME}"/fedsearchtest/kestrel-stixshifter-config.yaml

time kestrel upper-layer-integration/kestrel/test/huntflows/kestrel-scalability.hf