#!/bin/bash
CRT_DIR=${PWD}
mkdir -p "${HOME}"/fedsearchtest
cd "${HOME}"/fedsearchtest || exit
VIRTUALENV="$(which virtualenv)"
if [[ -z "$VIRTUALENV" ]]; then
    echo "virtualenv not installed, or not in the PATH env variable"
    echo "Attempting to create virtual environment using venv"
    
    if python3 -m venv fedsearchtest; then
	    echo "Successfully created virtual environment using venv"
    else
        echo "Please install virtualenv and/or venv and add its folder to PATH"
        exit 1
    fi
else
    "${VIRTUALENV}" -p python3 fedsearchtest
fi

echo "NB: This script created a virtual environment, but did not activate it."
echo "To activate, run:"
echo "    source ${HOME}/fedsearchtest/fedsearchtest/bin/activate"
cd "${CRT_DIR}" || exit
