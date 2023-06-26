#!/bin/bash
pip install behave
CRT_DIR="${PWD}"

# cd federated-search-core/stix-shifter/test || exit
behave --logging-level CRITICAL
# cd "${CRT_DIR}" || exit
