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
INSTANCE_COLOR="#29cc00"

# OutOfService output color (default red)
REGION_COLOR="#ff0033"

## Implementation (changes optional, not required)
regions="eu-west-1 eu-central-1"
#zones=$(aws ec2 describe-regions --output text | cut -f3)
# Fetch list of instances
for region in ${regions}
do
    number_of_running_instances=$(aws --profile ${AWS_CLI_PROFILE} ec2 describe-instances --region ${region} --filters 'Name=instance-state-code,Values=16'| jq '.Reservations[].Instances | length')
 	[[ -z ${number_of_running_instances} ]] && number_of_running_instances=0
 	total_number_of_running_instances=$((${total_number_of_running_instances} + ${number_of_running_instances}))
done

echo "$MENU_BAR_PREFIX_LABEL $total_number_of_running_instances"
echo "---"
for region in ${regions}
do
 	instances=$(aws --profile $AWS_CLI_PROFILE ec2 describe-instances --region ${region} --filters 'Name=instance-state-code,Values=16'|jq -r '.Reservations[].Instances[]| .PublicDnsName')
 	[[ ! -z ${instances} ]] && echo "${region} | color=$REGION_COLOR"
 	for instance in ${instances}
	do
		echo "${instance} | color=$INSTANCE_COLOR"
		echo "--Copy IP to clipboard | bash=\"echo ${instance} | pbcopy\" terminal=false"
	done
done
echo "Refresh | refresh=true"