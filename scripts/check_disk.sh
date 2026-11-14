#!/bin/bash
set -euo pipefail

THRESHOLD="${1:-80}"
USED=$(df --output=pcent / | tail -n 1 | tr -dc '0-9')

if [ "$USED" -gt "$THRESHOLD" ]; then
  echo "WARNING: диск заполнен на ${USED}% (порог ${THRESHOLD}%)"
  exit 1
fi
echo "OK: диск заполнен на ${USED}%"
