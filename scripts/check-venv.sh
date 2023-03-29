#!/bin/bash
INVENV=$( python3 -c 'import sys ; print( "" if sys.prefix == sys.base_prefix else 1 )' )
if [[ "$INVENV" == "" ]]
then
    echo "Not in a virtual environment, will not proceed with installation"
    echo "To install the testing environment:"
    echo "  1. Run 'make venv' to create a virtual environment"
    echo "  2. Run 'source ${HOME}/huntingtest/huntingtest/bin/activate' to activate virtual environment"
    exit 1
else
    if [[ "$VIRTUAL_ENV" != "${HOME}/huntingtest/huntingtest" ]]
    then
        echo "Current venv (${VIRTUAL_ENV}) is not huntingtest, will not proceed with installation"
        echo "To install and activate the huntingtest testing environment:"
        echo "  1. Run 'make venv' to create the huntingtest virtual environment"
        echo "  2. Run 'source ${HOME}/huntingtest/huntingtest/bin/activate' to activate virtual environment"
        exit 1
    fi
fi