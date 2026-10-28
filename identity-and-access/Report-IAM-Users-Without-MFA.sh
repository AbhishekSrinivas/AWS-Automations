#!/usr/bin/env bash
set -euo pipefail
# List IAM users that have no MFA device.
for U in $(aws iam list-users --query 'Users[].UserName' --output text); do
  N=$(aws iam list-mfa-devices --user-name "$U" --query 'length(MFADevices)' --output text)
  [ "$N" = 0 ] && echo "$U"
done
