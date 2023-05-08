#!/bin/bash
CRT_DIR=${PWD}
# shellcheck source=/dev/null
source "${HOME}"/huntingtest/huntingtest/bin/activate
"${CRT_DIR}"/scripts/prep-bdd-tests.sh
export KESTREL_STIXSHIFTER_CONFIG="${HOME}"/huntingtest/kestrel-stixshifter-config.yaml
behave --logging-level CRITICAL
cd "${CRT_DIR}" || exit
