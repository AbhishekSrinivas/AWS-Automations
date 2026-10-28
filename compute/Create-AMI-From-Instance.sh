#!/usr/bin/env bash
set -euo pipefail
# Create an AMI (image) from a running instance without rebooting it.
# Usage: ./Create-AMI-From-Instance.sh <instance-id> <image-name>
ID="${1:?instance id}"; NAME="${2:?image name}"
AMI=$(aws ec2 create-image --instance-id "$ID" --name "$NAME-$(date +%Y%m%d%H%M)" --no-reboot --query ImageId --output text)
echo "Creating $AMI"
aws ec2 wait image-available --image-ids "$AMI"
echo "Image $AMI is available"
