#!/bin/bash
KESTREL_BRANCH=${KESTREL_BRANCH:-develop}
KESTREL_REPO=${KESTREL_REPO:-kestrel-lang}
KESTREL_ORG=${KESTREL_ORG:-opencybersecurityalliance}

mkdir -p "${HOME}"/fedsearchtest
if [ ! -d "${HOME}/fedsearchtest/kestrel-lang" ]; then
    git clone -b "$KESTREL_BRANCH" git@github.com:"$KESTREL_ORG/$KESTREL_REPO".git "${HOME}/fedsearchtest/kestrel-lang"
fi