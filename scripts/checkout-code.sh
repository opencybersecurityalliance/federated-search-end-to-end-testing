#!/bin/bash
CRT_DIR="${PWD}"
mkdir -p "${HOME}"/huntingtest
cd "${HOME}"/huntingtest || exit
git clone git@github.com:opencybersecurityalliance/stix-shifter.git
git clone -b develop_stixshifter_v5 git@github.com:opencybersecurityalliance/kestrel-lang.git
cd "${CRT_DIR}" || exit
