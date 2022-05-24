###bash script for aws cli to create the backups


###Create backup plans
aws backup create-backup-plan --cli-input-json file://awir-p-devops-bkp-daily1week.json
aws backup create-backup-plan --cli-input-json file://awir-p-devops-bkp-dailymonthly1year.json
aws backup create-backup-plan --cli-input-json file://awir-p-devops-bkp-dailyweekly1month.json


accountID=$(aws sts get-caller-identity --query "Account" --output text)

sed -i "s/iam::.*:role/iam::$accountID:role/g" *.json

###Assign resources
aws backup create-backup-selection --cli-input-json file://ra_daily1week.json
aws backup create-backup-selection --cli-input-json file://ra_dailymontly1year.json
aws backup create-backup-selection --cli-input-json file://ra_dailyweekly1month.json


###give a-ok to the impersonation of the role by backup.amazonaws.com
update-assume-role-policy --role-name awir-p-devops-iar-backup --policy-document file://policy_assumption.json