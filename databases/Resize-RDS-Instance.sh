#!/usr/bin/env bash
set -euo pipefail
# Change the instance class of an RDS database.
# Usage: ./Resize-RDS-Instance.sh <db-instance-id> <db.instance.class> [apply-now]
DB="${1:?db instance id}"; CLASS="${2:?instance class}"
FLAG=$([ "${3:-}" = apply-now ] && echo --apply-immediately || echo --no-apply-immediately)
aws rds modify-db-instance --db-instance-identifier "$DB" --db-instance-class "$CLASS" $FLAG --query DBInstance.DBInstanceStatus --output text
