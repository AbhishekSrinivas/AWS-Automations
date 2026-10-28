# AWS Automation

Shell scripts for routine AWS admin work using the AWS CLI v2, plus one Lambda handler in Python.

- `compute/` launch an EC2 instance, start or stop by tag, resize, create an AMI
- `storage/` S3 retention rules, folder backup to S3, unattached EBS volumes, old snapshot clean-up
- `networking/` VPC with public and private subnets, security groups open to the internet
- `databases/` RDS snapshot and resize
- `identity-and-access/` users without MFA, old access keys
- `automation-runbooks/` EventBridge start/stop schedule, Lambda that stops tagged instances
- `monitoring-and-reporting/` EC2 inventory CSV, monthly cost by service
- `resource-management/` resources missing a tag

Scripts read their settings from arguments or environment variables. The ones that delete things only print what they would do unless you set `CONFIRM=yes`.

```bash
export AWS_PROFILE=<profile> AWS_REGION=us-east-1
./compute/Start-Stop-EC2-By-Tag.sh stop Schedule office-hours
```

These have not been run against a live account, so try them in a sandbox first.
