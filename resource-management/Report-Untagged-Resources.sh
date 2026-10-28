#!/usr/bin/env bash
set -euo pipefail
# List resources that are missing a required tag (uses the Resource Groups Tagging API).
# Usage: ./Report-Untagged-Resources.sh [required-tag-key]
KEY="${1:-Owner}"
aws resourcegroupstaggingapi get-resources --query "ResourceTagMappingList[?!(Tags[?Key==\`$KEY\`])].ResourceARN" --output text | tr '\t' '\n'
