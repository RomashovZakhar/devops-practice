#!/bin/bash
set -euo pipefail

BACKUP_DIR="${1:-./backups}"
KEEP_DAYS="${2:-7}"
FILE="$BACKUP_DIR/app_$(date +%F_%H%M%S).dump"

mkdir -p "$BACKUP_DIR"
docker compose exec -T db pg_dump -U app -d app -Fc > "$FILE"

if [ ! -s "$FILE" ]; then
  echo "FAIL: бэкап пустой, удаляю $FILE"
  rm -f "$FILE"
  exit 1
fi

find "$BACKUP_DIR" -name "app_*.dump" -mtime +"$KEEP_DAYS" -delete
echo "OK: $FILE ($(du -h "$FILE" | cut -f1))"