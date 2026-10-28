#!/usr/bin/env bash
set -euo pipefail
# Last full month of unblended cost grouped by service (Cost Explorer).
# Usage: ./Report-Monthly-Cost-By-Service.sh
START=$(date -u -d "$(date +%Y-%m-01) -1 month" +%Y-%m-%d)
END=$(date -u +%Y-%m-01)
aws ce get-cost-and-usage --time-period Start="$START",End="$END" --granularity MONTHLY \
  --metrics UnblendedCost --group-by Type=DIMENSION,Key=SERVICE \
  --query 'ResultsByTime[0].Groups[].[Keys[0],Metrics.UnblendedCost.Amount]' --output text | sort -k2 -nr
