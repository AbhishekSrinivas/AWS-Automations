#!/usr/bin/env bash
set -euo pipefail
# Expire objects after N days and clean up incomplete multipart uploads.
# Usage: ./Set-S3-Lifecycle-Retention.sh <bucket> [days] [prefix]
BUCKET="${1:?bucket}"; DAYS="${2:-90}"; PREFIX="${3:-}"
cat > /tmp/lifecycle.json <<J
{"Rules":[{"ID":"retention-${DAYS}d","Status":"Enabled","Filter":{"Prefix":"$PREFIX"},
 "Expiration":{"Days":$DAYS},"AbortIncompleteMultipartUpload":{"DaysAfterInitiation":7}}]}
J
aws s3api put-bucket-lifecycle-configuration --bucket "$BUCKET" --lifecycle-configuration file:///tmp/lifecycle.json
echo "Applied ${DAYS}-day retention to s3://$BUCKET/$PREFIX"
