#!/usr/bin/env bash

mysqldump -u "$DB_USER" -p"$DB_PASSWORD" ShopDB --no-create-db > backup-no-create-db.sql
mysql -u "$DB_USER" -p"$DB_PASSWORD" ShopDBReserve < backup-no-create-db.sql

mysqldump -u "$DB_USER" -p"$DB_PASSWORD" ShopDB --no-create-info > backup-no-create-info.sql
mysql -u "$DB_USER" -p"$DB_PASSWORD" ShopDBDevelopment < backup-no-create-info.sql