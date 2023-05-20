#!/bin/bash
KESTREL_ANALYTICS_BRANCH=${KESTREL_ANALYTICS_BRANCH:-release}
KESTREL_ANALYTICS_REPO=${KESTREL_ANALYTICS_REPO:-kestrel-analytics}
KESTREL_ANALYTICS_ORG=${KESTREL_ANALYTICS_ORG:-opencybersecurityalliance}

mkdir -p "${HOME}"/fedsearchtest
git clone -b "$KESTREL_ANALYTICS_BRANCH" git@github.com:"$KESTREL_ANALYTICS_ORG"/"$KESTREL_ANALYTICS_REPO".git "${HOME}"/fedsearchtest/kestrel-analytics