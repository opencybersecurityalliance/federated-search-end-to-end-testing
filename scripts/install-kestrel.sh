#!/bin/bash

# temp hack to bypass requests-2.29.0 incompatibility with stix-shifter setup.py
pip install requests==2.28.2
cd kestrel-lang || exit
pip install .
