#!/bin/bash
CRT_DIR=${PWD}
mkdir -p "${HOME}"/huntingtest
cd "${HOME}"/huntingtest || exit
"${CRT_DIR}"/import-data.sh
cd "${CRT_DIR}" || exit
