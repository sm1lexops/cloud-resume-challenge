#############################################################################
###         CREATE VPC, Subnets, Route Table
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
LABEL3="Enter Public Subnet CIDR block (e.g., 10.0.1.0/24 should be included into VPC CIDR): " 
LABEL3_1="Enter Private Subnet CIDR block (e.g., 10.0.2.0/24 should be included into VPC CIDR): "
LABEL4=" Public Subnet created successfully! "
LABEL4_1=" Private Subnet created successfully!"
LABEL4_2=" Route Table created and public subnet associated successfully! "

#############################################################################
###         VPC
#############################################################################
printf "${CYAN}==== ${LABEL1}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
read -p "vpc_cidr: " vpc_cidr
pattern_vpc_cidr='^([0-9]{1,3}\.){3}[0-9]{1,3}/(1[6-9]|2[0-8])$'
printf "${CYAN}==== ${LABEL1_01}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
read -p "aws_region: " aws_region
printf "${CYAN}==== ${LABEL1_02}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
read -p "aws_tag_name: " aws_tag_name

if [[ "$vpc_cidr" =~ $pattern_vpc_cidr ]]; then
    # Create VPC
    vpc_id=$(aws ec2 create-vpc --cidr-block "$vpc_cidr" --region "$aws_region" --query 'Vpc.VpcId' --output text)
    echo "VPC: $vpc_id"
    aws ec2 create-tags --resources "$vpc_id" --region "$aws_region" --tags Key=Name,Value="$aws_tag_name" 
    printf "${GREEN}==== ${LABEL1_1} $vpc_id${NO_COLOR} ${GREEN}======${NO_COLOR}\n"
else
    printf "${RED}==== ${LABEL1_2}${NO_COLOR} ${RED}======${NO_COLOR}\n"
    exit 1
fi
#############################################################################
###         IGW
#############################################################################
printf "${CYAN}==== ${LABEL2}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
read -p "igw_name_tag: " igw_name_tag

if [[ "$vpc_cidr" =~ $pattern_vpc_cidr ]]; then
    # Create Internet Gateway
    internet_gateway_id=$(aws ec2 create-internet-gateway --region "$aws_region" --query 'InternetGateway.InternetGatewayId' --output text)
    # Add Name tag to the Internet Gateway
    aws ec2 create-tags --resources "$internet_gateway_id" --region "$aws_region" --tags Key=Name,Value="$igw_name_tag"

    # Attach Internet Gateway to the VPC
    aws ec2 attach-internet-gateway --vpc-id "$vpc_id" --internet-gateway-id "$internet_gateway_id"

    printf "${GREEN}==== ${LABEL2_1} $internet_gateway_id${NO_COLOR} ${GREEN}======${NO_COLOR}\n"
else
    printf "${RED}==== ${LABEL2_2}${NO_COLOR} ${RED}======${NO_COLOR}\n"
    exit 1
fi
#############################################################################
###         Subnets and Route Table
#############################################################################
printf "${CYAN}==== ${LABEL3}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
read -p "public_subnet_cidr: " public_subnet_cidr

printf "${CYAN}==== ${LABEL3_1}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
read -p "private_subnet_cidr: " private_subnet_cidr

# Create Public Subnet
public_subnet_id=$(aws ec2 create-subnet --vpc-id "$vpc_id" --cidr-block "$public_subnet_cidr" --availability-zone "${aws_region}a" --query 'Subnet.SubnetId' --output text)

# Add Name tag to the Public Subnet
aws ec2 create-tags --resources "$public_subnet_id" --tags Key=Name,Value=PublicSubnet
printf "${CYAN}==== ${LABEL4}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
# Create Private Subnet
private_subnet_id=$(aws ec2 create-subnet --vpc-id "$vpc_id" --cidr-block "$private_subnet_cidr" --availability-zone "${aws_region}b" --query 'Subnet.SubnetId' --output text)

# Add Name tag to the Private Subnet
aws ec2 create-tags --resources "$private_subnet_id" --tags Key=Name,Value=PrivateSubnet
printf "${CYAN}==== ${LABEL4_1}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
# Create Route Table
route_table_id=$(aws ec2 create-route-table --vpc-id "$vpc_id" --query 'RouteTable.RouteTableId' --output text)

# Add Name tag to the Route Table
aws ec2 create-tags --resources "$route_table_id" --tags Key=Name,Value=MyRouteTable
printf "${CYAN}==== ${LABEL4_2}${NO_COLOR} ${CYAN}======${NO_COLOR}\n"
# Create a default route to the Internet Gateway in the Route Table
aws ec2 create-route --route-table-id "$route_table_id" --destination-cidr-block 0.0.0.0/0 --gateway-id "$internet_gateway_id"

# Associate the Public Subnet with the Route Table
aws ec2 associate-route-table --subnet-id "$public_subnet_id" --route-table-id "$route_table_id"

export LABEL5=$(cat <<EOF
Created Successfully:
VPC: $vpc_id
IGW: $internet_gateway_id
public_subnet: $public_subnet_id $public_subnet_cidr
private_subnet: $private_subnet_id $private_subnet_cidr
route-table: $route_table_id
Public Subnet have access to the Internet with Route to IGW
EOF
) 
printf "${GREEN}==== ${LABEL5}${NO_COLOR} ${GREEN}======${NO_COLOR}\n"
