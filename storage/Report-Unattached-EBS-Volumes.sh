#!/usr/bin/env bash
set -euo pipefail
# List EBS volumes that are not attached to any instance (cost clean-up candidates).
# Usage: ./Report-Unattached-EBS-Volumes.sh [region]
REGION="${1:-${AWS_REGION:-us-east-1}}"
aws ec2 describe-volumes --region "$REGION" --filters Name=status,Values=available \
  --query 'Volumes[].[VolumeId,Size,VolumeType,CreateTime,Tags[?Key==`Name`]|[0].Value]' --output table
