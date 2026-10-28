#!/usr/bin/env bash
set -euo pipefail
# Create a manual snapshot of an RDS instance and wait for it.
# Usage: ./Snapshot-RDS-Instance.sh <db-instance-id>
DB="${1:?db instance id}"; SNAP="$DB-$(date +%Y%m%d%H%M)"
aws rds create-db-snapshot --db-instance-identifier "$DB" --db-snapshot-identifier "$SNAP" >/dev/null
aws rds wait db-snapshot-available --db-snapshot-identifier "$SNAP"
echo "Snapshot $SNAP ready"
