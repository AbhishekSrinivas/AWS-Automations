#!/usr/bin/env bash
set -euo pipefail
# Export all EC2 instances in a region to CSV.
# Usage: ./Export-EC2-Inventory-CSV.sh [region] > ec2-inventory.csv
REGION="${1:-${AWS_REGION:-us-east-1}}"
echo "InstanceId,Name,Type,State,PrivateIp,PublicIp,LaunchTime"
aws ec2 describe-instances --region "$REGION" --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`]|[0].Value,InstanceType,State.Name,PrivateIpAddress,PublicIpAddress,LaunchTime]' --output text | tr '\t' ','
