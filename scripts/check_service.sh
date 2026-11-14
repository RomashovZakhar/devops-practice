#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Использование: $0 имя_сервиса"
  exit 2
fi

SERVICE="$1"

if systemctl is-active --quiet "$SERVICE"; then
  echo "OK: $SERVICE работает"
  exit 0
else
  echo "FAIL: $SERVICE не работает"
  exit 1
fi
