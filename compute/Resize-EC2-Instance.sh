#!/usr/bin/env bash
set -euo pipefail
# Change the instance type (the instance is stopped and restarted).
# Usage: ./Resize-EC2-Instance.sh <instance-id> <new-type>
ID="${1:?instance id}"; TYPE="${2:?new instance type}"
aws ec2 stop-instances --instance-ids "$ID" >/dev/null
aws ec2 wait instance-stopped --instance-ids "$ID"
aws ec2 modify-instance-attribute --instance-id "$ID" --instance-type "{\"Value\":\"$TYPE\"}"
aws ec2 start-instances --instance-ids "$ID" >/dev/null
aws ec2 wait instance-running --instance-ids "$ID"
echo "$ID is now $TYPE"
