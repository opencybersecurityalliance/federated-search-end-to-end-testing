#!/bin/bash

# temp hack to bypass requests-2.29.0 incompatibility with stix-shifter setup.py
pip install requests==2.28.2

CRT_DIR=${PWD}
if [ -d "${HOME}/fedsearchtest/stix-shifter" ]; then
    WORKING_DIR="${HOME}/fedsearchtest/stix-shifter"
else
    WORKING_DIR=stix-shifter
fi

cd "$WORKING_DIR" || exit

if [ -z "$STIX_SHIFTER_TEST_VERSION" ]; then
    python3 setup.py install
else
    VERSION="$STIX_SHIFTER_TEST_VERSION" python3 setup.py install
fi
cd "${CRT_DIR}" || exit