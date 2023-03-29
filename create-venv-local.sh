#!/bin/bash -x
CRT_DIR=${PWD}
mkdir -p "${HOME}"/huntingtest
cd "${HOME}"/huntingtest || exit
pip install --upgrade pip wheel
VIRTUALENV="${HOME}"/.local/bin/virtualenv
if [[ -f /usr/bin/virtualenv ]]; then
	VIRTUALENV=/usr/bin/virtualenv
fi
"${VIRTUALENV}" -p python3 huntingtest
echo "NB: This script created a virtual environment, but did not activate it."
echo "To activate, run \"source ${HOME}/huntingtest/huntingtest/bin/activate\""
cd "${CRT_DIR}" || exit
