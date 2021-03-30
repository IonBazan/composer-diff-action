#!/bin/sh

set -e

OUTPUT=$(composer diff $*)
echo "$OUTPUT"

OUTPUT=$(echo "$OUTPUT" | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g')
OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "::set-output name=composer_diff::$OUTPUT"
