#!/usr/bin/env bash
set -euo pipefail
# Find security group rules open to the whole internet (0.0.0.0/0).
# Usage: ./Audit-Security-Groups.sh [region]
REGION="${1:-${AWS_REGION:-us-east-1}}"
aws ec2 describe-security-groups --region "$REGION" \
  --query 'SecurityGroups[?IpPermissions[?IpRanges[?CidrIp==`0.0.0.0/0`]]].[GroupId,GroupName,VpcId]' --output table
