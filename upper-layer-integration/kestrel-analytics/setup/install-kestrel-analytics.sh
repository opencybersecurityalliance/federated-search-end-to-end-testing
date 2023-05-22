#!/bin/bash

CRT_DIR="${PWD}"
if [ -d "${HOME}/fedsearchtest/kestrel-analytics" ]; then
    WORKING_DIR="${HOME}/fedsearchtest/kestrel-analytics/analytics/domainnamelookup"
else
    WORKING_DIR=kestrel-analytics/analytics/domainnamelookup
fi
cd "$WORKING_DIR" || exit
sudo docker build -t kestrel-analytics-domainnamelookup .
cd "${CRT_DIR}" || exit