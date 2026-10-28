#!/usr/bin/env bash
set -euo pipefail
# Start or stop all instances that carry a tag, for example a nightly schedule.
# Usage: ./Start-Stop-EC2-By-Tag.sh <start|stop> [tag-key] [tag-value]
ACTION="${1:?start or stop}"
KEY="${2:-Schedule}"
VALUE="${3:-office-hours}"
STATE=$([ "$ACTION" = start ] && echo stopped || echo running)

IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:$KEY,Values=$VALUE" "Name=instance-state-name,Values=$STATE" \
  --query 'Reservations[].Instances[].InstanceId' --output text)
if [ -z "$IDS" ]; then echo "No $STATE instances tagged $KEY=$VALUE"; exit 0; fi
case "$ACTION" in
  start) aws ec2 start-instances --instance-ids $IDS --output table ;;
  stop)  aws ec2 stop-instances  --instance-ids $IDS --output table ;;
  *) echo "Unknown action $ACTION" >&2; exit 1 ;;
esac
