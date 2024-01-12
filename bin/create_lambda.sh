#############################################################################
###         CREATE Lambda Function
#############################################################################
#! /usr/bin/env bash
set -e
# Regular Colors
#Black='\033[0;30m'        # Black
#Red='\033[0;31m'          # Red
#Green='\033[0;32m'        # Green
#Yellow='\033[0;33m'       # Yellow
#Blue='\033[0;34m'         # Blue
#Purple='\033[0;35m'       # Purple
#Cyan='\033[0;36m'         # Cyan
#White='\033[0;37m'        # White

CYAN='\033[1;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NO_COLOR='\033[0m'
LABEL1="Enter VPC CIDR block (e.g., 10.0.0.0/xx; 172.16.0.0/16; 192.168.0.0/28, mask between 16 and 28): "
LABEL1_01="Enter AWS Region (e.g., us-east-1): "
LABEL1_02="Enter VPC Tag name (e.g., ResumeChallengeVPC): "
LABEL1_1="VPC: created successfully! "
LABEL1_2="Error: Entered CIDR block is not in the correct IPv4 CIDR format (e.g., xx.xx.xx.xx/xx). Exiting."
LABEL2="Enter IGW name (e.g., s3-igw): "
LABEL2_1="IGW created successfully and attached to the VPC IGW: !"
LABEL2_2="Error: igw can't be created, see logs"

# Create the Lambda function
aws lambda create-function \
    --function-name CheckWhitelistFunction \
    --runtime python3.8 \
    --handler lambda_check_ec2.lambda_handler \
    --role YOUR_LAMBDA_EXECUTION_ROLE_ARN \
    --zip-file fileb://lambda_check_ec2.py