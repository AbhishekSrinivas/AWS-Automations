"""Lambda handler: stop all running EC2 instances tagged Schedule=office-hours.

Deploy with a role that allows ec2:DescribeInstances and ec2:StopInstances, then
trigger it from an EventBridge schedule.
"""
import boto3

ec2 = boto3.client("ec2")


def handler(event, context):
    resp = ec2.describe_instances(
        Filters=[
            {"Name": "tag:Schedule", "Values": [event.get("tag_value", "office-hours")]},
            {"Name": "instance-state-name", "Values": ["running"]},
        ]
    )
    ids = [i["InstanceId"] for r in resp["Reservations"] for i in r["Instances"]]
    if ids:
        ec2.stop_instances(InstanceIds=ids)
    return {"stopped": ids}
