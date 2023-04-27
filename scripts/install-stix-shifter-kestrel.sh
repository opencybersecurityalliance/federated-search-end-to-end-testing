#!/bin/bash

# temp hack to bypass requests-2.29.0 incompatibility with stix-shifter setup.py
pip install requests==2.28.2
cd stix-shifter || exit
VERSION=9.9.99 python3 setup.py install
cd ../kestrel-lang || exit
sed -i 's/.*stix-shifter-utils.*/    stix-shifter-utils==9.9.99/' setup.cfg
sed -i 's/.*stix-shifter=.*/    stix-shifter==9.9.99/' setup.cfg
sed -i 's/.*stix-shifter>.*/    stix-shifter==9.9.99/' setup.cfg
pip install .
