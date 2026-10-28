#!/usr/bin/env bash
set -euo pipefail
# List access keys older than N days.
# Usage: ./Report-Old-Access-Keys.sh [days]
DAYS="${1:-90}"
CUTOFF=$(date -u -d "-$DAYS days" +%Y-%m-%dT%H:%M:%S)
for U in $(aws iam list-users --query 'Users[].UserName' --output text); do
  aws iam list-access-keys --user-name "$U" \
    --query "AccessKeyMetadata[?CreateDate<'$CUTOFF'].[UserName,AccessKeyId,Status,CreateDate]" --output text
done
