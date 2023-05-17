#!/bin/bash
CRT_DIR="${PWD}"

STIX_SHIFTER_BRANCH=${STIX_SHIFTER_BRANCH:-develop}
KESTREL_BRANCH=${KESTREL_BRANCH:-develop}
KESTREL_ANALYTICS_BRANCH=${KESTREL_ANALYTICS_BRANCH:-release}

STIX_SHIFTER_ORG=${STIX_SHIFTER_ORG:-opencybersecurityalliance}
KESTREL_ORG=${KESTREL_ORG:-opencybersecurityalliance}
KESTREL_ANALYTICS_ORG=${KESTREL_ANALYTICS_ORG:-opencybersecurityalliance}

mkdir -p "${HOME}"/huntingtest
cd "${HOME}"/huntingtest || exit
git clone -b "$STIX_SHIFTER_BRANCH" git@github.com:"$STIX_SHIFTER_ORG"/stix-shifter.git
git clone -b "$KESTREL_BRANCH" git@github.com:"$KESTREL_ORG"/kestrel-lang.git
git clone -b "$KESTREL_ANALYTICS_BRANCH" git@github.com:"$KESTREL_ANALYTICS_ORG"/kestrel-analytics.git
cd "${CRT_DIR}" || exit
