# AWS Automation

Small, readable shell and Python scripts for everyday AWS administration: instance lifecycle, storage clean-up, networking, databases, access reviews, scheduling and reporting.

## Requirements

- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), configured with `aws configure sso` or an assumed role
- Bash 4+ (Linux, macOS with GNU coreutils, or WSL)
- Python 3.9+ with `boto3` only for the Lambda example

Every script uses `set -euo pipefail`, takes values from arguments or environment variables, and never contains credentials. Destructive scripts default to a dry run.

## Layout

| Folder | Scripts |
|---|---|
| `compute/` | Create an EC2 instance, start or stop by tag, resize, create an AMI |
| `storage/` | S3 lifecycle retention, folder backup to S3, unattached EBS report, old snapshot clean-up |
| `networking/` | VPC with public and private subnets, open security group audit |
| `databases/` | RDS snapshot and resize |
| `identity-and-access/` | Users without MFA, old access keys |
| `automation-runbooks/` | EventBridge Scheduler start/stop, Lambda handler to stop tagged instances |
| `monitoring-and-reporting/` | EC2 inventory to CSV, monthly cost by service |
| `resource-management/` | Tag compliance report |

## Usage

```bash
export AWS_PROFILE=<your-profile> AWS_REGION=us-east-1
./compute/Start-Stop-EC2-By-Tag.sh stop Schedule office-hours
CONFIRM=yes ./storage/Delete-Old-EBS-Snapshots.sh 60
```

Placeholders such as `<instance-id>` and `<role-arn>` are values you supply.

## Safety

- Run against a sandbox account first.
- Use least-privilege IAM roles; each script lists the API calls it needs in its commands.
- Do not commit credentials, keys or account IDs. The `.gitignore` blocks common secret files.
