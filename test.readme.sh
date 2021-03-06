#! /usr/bin/env bash

set -e

SOURCE=$(awk 'f{ if (/DOCTEST/){printf "%s", buf; f=0; buf=""} else buf = buf $0 ORS}; /DOCTEST/{f=1}' README.md)
echo "${SOURCE}" > doctest.pl

T1=$(
swipl -s doctest.pl -g "handler(json([fullName='Nicholas']), context(headers(['TZ'('PST')]), _), Response), write(Response)." -t halt | \
    jq '.possibleNames' | \
    jq 'length'
)
T2=$(
swipl -s doctest.pl -g "handler(json([]), context(headers(['TZ'('PST')]), _), Response), write(Response)." -t halt | \
    jq '.possibleNames' | \
    jq 'length'
)


[ -f assert.sh ] || wget https://raw.github.com/lehmannro/assert.sh/v1.1/assert.sh -O assert.sh &>/dev/null
. assert.sh

assert "echo '${T1}'" 2
assert "echo '${T2}'" 5

assert_end "doc_test"