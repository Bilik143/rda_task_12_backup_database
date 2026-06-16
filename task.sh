#!/usr/bin/env bash
set -euo pipefail

: "${DB_USER:?Environment variable DB_USER is required}"
: "${DB_PASSWORD:?Environment variable DB_PASSWORD is required}"
DB_HOST=${DB_HOST:-localhost}

FULL_BACKUP_FILE=$(mktemp /tmp/ShopDB_full_backup.XXXXXX.sql)
DATA_BACKUP_FILE=$(mktemp /tmp/ShopDB_data_backup.XXXXXX.sql)

cleanup() {
  rm -f "$FULL_BACKUP_FILE" "$DATA_BACKUP_FILE"
}
trap cleanup EXIT

echo "Creating full backup of ShopDB..."
mysqldump \
  -h "$DB_HOST" \
  -u"$DB_USER" \
  -p"$DB_PASSWORD" \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  ShopDB > "$FULL_BACKUP_FILE"

echo "Restoring full backup into ShopDBReserve..."
mysql \
  -h "$DB_HOST" \
  -u"$DB_USER" \
  -p"$DB_PASSWORD" \
  ShopDBReserve < "$FULL_BACKUP_FILE"

echo "Creating data-only backup of ShopDB..."
mysqldump \
  -h "$DB_HOST" \
  -u"$DB_USER" \
  -p"$DB_PASSWORD" \
  --single-transaction \
  --no-create-info \
  ShopDB > "$DATA_BACKUP_FILE"

echo "Restoring data backup into ShopDBDevelopment..."
mysql \
  -h "$DB_HOST" \
  -u"$DB_USER" \
  -p"$DB_PASSWORD" \
  ShopDBDevelopment < "$DATA_BACKUP_FILE"

echo "Backup and restore completed successfully."
