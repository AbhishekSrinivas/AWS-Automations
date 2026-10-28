#!/usr/bin/env bash
set -euo pipefail
# Sync a local folder to S3 with server-side encryption.
# Usage: ./Backup-Folder-To-S3.sh <local-folder> <bucket> [prefix]
SRC="${1:?local folder}"; BUCKET="${2:?bucket}"; PREFIX="${3:-backups/$(hostname)}"
aws s3 sync "$SRC" "s3://$BUCKET/$PREFIX" --sse AES256 --storage-class STANDARD_IA --only-show-errors
echo "Synced $SRC to s3://$BUCKET/$PREFIX"
