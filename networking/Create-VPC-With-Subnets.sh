#!/usr/bin/env bash
set -euo pipefail
# Create a VPC with one public and one private subnet and an internet gateway.
# Usage: ./Create-VPC-With-Subnets.sh <name> [vpc-cidr]
NAME="${1:?name}"; CIDR="${2:-10.20.0.0/16}"
VPC=$(aws ec2 create-vpc --cidr-block "$CIDR" --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$NAME}]" --query Vpc.VpcId --output text)
aws ec2 modify-vpc-attribute --vpc-id "$VPC" --enable-dns-hostnames
PUB=$(aws ec2 create-subnet --vpc-id "$VPC" --cidr-block 10.20.1.0/24 --query Subnet.SubnetId --output text)
PRIV=$(aws ec2 create-subnet --vpc-id "$VPC" --cidr-block 10.20.2.0/24 --query Subnet.SubnetId --output text)
IGW=$(aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text)
aws ec2 attach-internet-gateway --internet-gateway-id "$IGW" --vpc-id "$VPC"
RT=$(aws ec2 create-route-table --vpc-id "$VPC" --query RouteTable.RouteTableId --output text)
aws ec2 create-route --route-table-id "$RT" --destination-cidr-block 0.0.0.0/0 --gateway-id "$IGW" >/dev/null
aws ec2 associate-route-table --route-table-id "$RT" --subnet-id "$PUB" >/dev/null
echo "VPC=$VPC public=$PUB private=$PRIV igw=$IGW"
