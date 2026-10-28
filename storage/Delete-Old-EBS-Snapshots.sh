#!/usr/bin/env bash
set -euo pipefail
# Delete snapshots you own that are older than N days. Dry run unless CONFIRM=yes.
# Usage: [CONFIRM=yes] ./Delete-Old-EBS-Snapshots.sh [days]
DAYS="${1:-30}"
CUTOFF=$(date -u -d "-$DAYS days" +%Y-%m-%dT%H:%M:%S)
aws ec2 describe-snapshots --owner-ids self --query "Snapshots[?StartTime<'$CUTOFF'].SnapshotId" --output text | tr '\t' '\n' | while read -r SNAP; do
  [ -z "$SNAP" ] && continue
  if [ "${CONFIRM:-no}" = yes ]; then aws ec2 delete-snapshot --snapshot-id "$SNAP" && echo "Deleted $SNAP"; else echo "Would delete $SNAP"; fi
done
