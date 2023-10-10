#!/bin/bash

CRT_DIR="${PWD}"
if [ -d "${HOME}/fedsearchtest/kestrel-lang" ]; then
    WORKING_DIR="${HOME}/fedsearchtest/kestrel-lang"
else
    WORKING_DIR=kestrel-lang
fi
cd "$WORKING_DIR" || exit

if [ -n "$STIX_SHIFTER_TEST_VERSION" ]; then
    sed -i "s/.*stix-shifter-utils.*/    stix-shifter-utils==$STIX_SHIFTER_TEST_VERSION/" setup.cfg
    sed -i "s/.*stix-shifter=.*/    stix-shifter==$STIX_SHIFTER_TEST_VERSION/" setup.cfg
    sed -i "s/.*stix-shifter>.*/    stix-shifter==$STIX_SHIFTER_TEST_VERSION/" setup.cfg
fi
make install
cd "${CRT_DIR}" || exit
