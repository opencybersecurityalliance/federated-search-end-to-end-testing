#!/bin/bash
STIX_SHIFTER_BRANCH=${STIX_SHIFTER_BRANCH:-develop}
STIX_SHIFTER_REPO=${STIX_SHIFTER_REPO:-stix-shifter}
STIX_SHIFTER_ORG=${STIX_SHIFTER_ORG:-opencybersecurityalliance}

mkdir -p "${HOME}"/fedsearchtest
if [ ! -d "${HOME}/fedsearchtest/stix-shifter" ]; then
    git clone -b "$STIX_SHIFTER_BRANCH" git@github.com:"$STIX_SHIFTER_ORG/$STIX_SHIFTER_REPO".git "${HOME}/fedsearchtest/stix-shifter"
fi