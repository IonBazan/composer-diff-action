#!/bin/bash

git config --global --add safe.directory "$GITHUB_WORKSPACE"

ARGS=$*
OUTPUT=$(composer diff --strict $ARGS)
EXIT_CODE=$?

set -e

echo "$OUTPUT"

echo "composer_diff_exit_code=$EXIT_CODE" >> $GITHUB_OUTPUT

delimiter="$(openssl rand -hex 8)"
echo "composer_diff<<${delimiter}" >> "${GITHUB_OUTPUT}"
echo "${OUTPUT}" >> "${GITHUB_OUTPUT}"
echo "${delimiter}" >> "${GITHUB_OUTPUT}"

if [[ "$*" == *"--strict"* ]]; then
  exit $EXIT_CODE
fi
