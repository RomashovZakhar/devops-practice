#!/bin/bash
set -euo pipefail

FAILED=0
for S in nginx cron; do
  if ! ~/lab/check_service.sh "$S"; then
    FAILED=$((FAILED + 1))
  fi
done

if [ "$FAILED" -gt 0 ]; then
  echo "Итого упало: $FAILED"
  exit 1
fi
echo "Все сервисы в порядке"
exit 0
