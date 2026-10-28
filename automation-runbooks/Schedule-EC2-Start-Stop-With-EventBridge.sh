#!/usr/bin/env bash
set -euo pipefail
# Create two EventBridge Scheduler rules that invoke the SSM Automation documents
# AWS-StartEC2Instance / AWS-StopEC2Instance for tagged instances.
# Prerequisite: an IAM role that EventBridge can assume to run SSM Automation (ROLE_ARN).
# Usage: ROLE_ARN=<role-arn> ./Schedule-EC2-Start-Stop-With-EventBridge.sh <instance-id>
ID="${1:?instance id}"; : "${ROLE_ARN:?set ROLE_ARN}"
REGION="${AWS_REGION:-us-east-1}"
for ACT in Start Stop; do
  CRON=$([ "$ACT" = Start ] && echo 'cron(0 8 ? * MON-FRI *)' || echo 'cron(0 19 ? * MON-FRI *)')
  aws scheduler create-schedule --name "ec2-${ACT,,}-$ID" --schedule-expression "$CRON" \
    --flexible-time-window Mode=OFF \
    --target "{\"Arn\":\"arn:aws:scheduler:::aws-sdk:ssm:startAutomationExecution\",\"RoleArn\":\"$ROLE_ARN\",\"Input\":\"{\\\"DocumentName\\\":\\\"AWS-${ACT}EC2Instance\\\",\\\"Parameters\\\":{\\\"InstanceId\\\":[\\\"$ID\\\"]}}\"}" >/dev/null
  echo "Created ${ACT,,} schedule for $ID ($CRON, UTC)"
done
