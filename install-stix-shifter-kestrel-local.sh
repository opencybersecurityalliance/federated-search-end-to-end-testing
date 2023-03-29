#!/bin/bash
CRT_DIR=${PWD}
# shellcheck source=/dev/null
source "${HOME}"/huntingtest/huntingtest/bin/activate
cd "${HOME}"/huntingtest || exit
"${CRT_DIR}"/install-stix-shifter-kestrel.sh
cd "${CRT_DIR}" || exit