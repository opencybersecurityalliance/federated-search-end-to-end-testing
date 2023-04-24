#!/bin/bash
CRT_DIR=${PWD}
# shellcheck source=/dev/null
source "${HOME}"/huntingtest/huntingtest/bin/activate
cd "${HOME}"/huntingtest || exit
"${CRT_DIR}"/scripts/prep-bdd-tests.sh
cd "${CRT_DIR}" || exit
behave --logging-level CRITICAL
cd "${CRT_DIR}" || exit
