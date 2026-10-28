#!/usr/bin/env bash
set -euo pipefail
# Launch an EC2 instance with a name tag.
# Usage: AMI_ID=<ami-id> SUBNET_ID=<subnet-id> SG_ID=<sg-id> KEY_NAME=<key-pair> ./Create-EC2-Instance.sh <name> [instance-type]
NAME="${1:?instance name required}"
TYPE="${2:-t3.micro}"
: "${AMI_ID:?set AMI_ID}" "${SUBNET_ID:?set SUBNET_ID}" "${SG_ID:?set SG_ID}" "${KEY_NAME:?set KEY_NAME}"

ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" --instance-type "$TYPE" \
  --subnet-id "$SUBNET_ID" --security-group-ids "$SG_ID" --key-name "$KEY_NAME" \
  --metadata-options HttpTokens=required \
  --block-device-mappings 'DeviceName=/dev/xvda,Ebs={VolumeSize=20,VolumeType=gp3,Encrypted=true}' \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME},{Key=Owner,Value=${OWNER:-unassigned}}]" \
  --query 'Instances[0].InstanceId' --output text)
echo "Launched $ID, waiting for running state..."
aws ec2 wait instance-running --instance-ids "$ID"
aws ec2 describe-instances --instance-ids "$ID" --query 'Reservations[0].Instances[0].[InstanceId,State.Name,PrivateIpAddress]' --output text
