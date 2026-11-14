#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

FAILED=0
for S in nginx cron; do
  if ! "$SCRIPT_DIR/check_service.sh" "$S"; then
    FAILED=$((FAILED + 1))
  fi
done

if [ "$FAILED" -gt 0 ]; then
  echo "Итого упало: $FAILED"
  exit 1
fi
echo "Все сервисы в порядке"
exit 0
