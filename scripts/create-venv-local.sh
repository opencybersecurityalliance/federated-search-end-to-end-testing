#!/bin/bash
CRT_DIR=${PWD}
mkdir -p "${HOME}"/huntingtest
cd "${HOME}"/huntingtest || exit
# pip install --upgrade pip wheel
VIRTUALENV="$(which virtualenv)"
if [[ -z "$VIRTUALENV" ]]; then
    echo "virtualenv not installed, or not in the PATH env variable"
    echo "Please install virtualenv and/or add its folder to PATH"
    exit 1
fi
"${VIRTUALENV}" -p python3 huntingtest
echo "NB: This script created a virtual environment, but did not activate it."
echo "To activate, run \"source ${HOME}/huntingtest/huntingtest/bin/activate\""
cd "${CRT_DIR}" || exit