#!/bin/bash
INVENV=$( python3 -c 'import sys ; print( "" if sys.prefix == sys.base_prefix else 1 )' )
if [[ "$INVENV" == "" ]]
then
    echo "Not in a virtual environment, will not proceed with installation"
    echo "To install the testing environment:"
    echo "  1. Run 'make venv' to create a virtual environment"
    echo "  2. Run 'source ${HOME}/fedsearchtest/fedsearchtest/bin/activate' to activate virtual environment"
    exit 1
else
    if [[ "$VIRTUAL_ENV" != "${HOME}/fedsearchtest/fedsearchtest" ]]
    then
        echo "Current venv (${VIRTUAL_ENV}) is not fedsearchtest, will not proceed with installation"
        echo "To install and activate the fedsearchtest testing environment:"
        echo "  1. Run 'make venv' to create the fedsearchtest virtual environment"
        echo "  2. Run 'source ${HOME}/fedsearchtest/fedsearchtest/bin/activate' to activate virtual environment"
        exit 1
    fi
fi