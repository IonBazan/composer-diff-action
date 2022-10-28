#!/bin/bash

git config --global --add safe.directory "$GITHUB_WORKSPACE"

ARGS=$*
OUTPUT=$(composer diff --strict $ARGS)
EXIT_CODE=$?

set -e

echo "$OUTPUT"

OUTPUT=$(echo -n "$OUTPUT" | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g')
OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "composer_diff_exit_code=$EXIT_CODE" >> $GITHUB_OUTPUT
echo -n "composer_diff=$OUTPUT" >> $GITHUB_OUTPUT

if [[ "$*" == *"--strict"* ]]; then
  exit $EXIT_CODE
fi
