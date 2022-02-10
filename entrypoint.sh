#!/bin/sh

set -e

OUTPUT=$(composer diff --strict $*)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo "::set-output name=composer_diff::"
else
  echo "$OUTPUT"

  OUTPUT=$(echo "$OUTPUT" | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g')
  OUTPUT="${OUTPUT//'%'/'%25'}"
  OUTPUT="${OUTPUT//$'\n'/'%0A'}"
  OUTPUT="${OUTPUT//$'\r'/'%0D'}"

  echo "::set-output name=composer_diff::$OUTPUT"
fi

echo "::set-output name=composer_diff_exit_code::$EXIT_CODE"
