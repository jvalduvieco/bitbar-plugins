#!/bin/bash

# Number of EC2 instances running
#   Dropdown with healthy and unhealthy totals
#
# by Jonathan Keith (http://github.com/joncse)
#
# <bitbar.title>AWS alive instanves</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Joan Valduvieco</bitbar.author>
# <bitbar.author.github>jvalduvieco</bitbar.author.github>
# <bitbar.desc>Shows alive instances in AWS</bitbar.desc>
# <bitbar.dependencies>awscli</bitbar.dependencies>
# <bitbar.image>http://i.imgur.com/nQ6LzvZ.png</bitbar.image>
#
# Dependencies: 
#   awscli (https://aws.amazon.com/cli/)

export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

## Required Configuration (must provide your own settings here)

# AWS CLI credential profile
AWS_CLI_PROFILE="default"

## Optional Configuration (not required)

# Prefix label
MENU_BAR_PREFIX_LABEL="EC2: "

# InService output color (default green)
IN_SERVICE_COLOR="#29cc00"

# OutOfService output color (default red)
OUT_SERVICE_COLOR="#ff0033"

## Implementation (changes optional, not required)

# Fetch list of instances
for region in $(aws ec2 describe-regions --output text | cut -f3)
do
    number_of_running_instances=$(aws --profile ${AWS_CLI_PROFILE} ec2 describe-instances --region ${region} --filters 'Name=instance-state-code,Values=16'| jq '.Reservations[].Instances | length')
 	[[ -z ${number_of_running_instances} ]] && number_of_running_instances=0
 	instances=$(aws --profile $AWS_CLI_PROFILE ec2 describe-instances --region ${region} --filters 'Name=instance-state-code,Values=16'|jq -r '.Reservations[].Instances[]| .PublicDnsName')
 	total_number_of_running_instances=$((${total_number_of_running_instances} + ${number_of_running_instances}))
 	total_instances+="${instances[@]}"
done


# Output
echo "$MENU_BAR_PREFIX_LABEL $total_number_of_running_instances"
echo "---"
for instance in $total_instances
do
	echo "${instance} | color=$IN_SERVICE_COLOR"
done
