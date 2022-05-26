###bash script for aws cli to create the backups


###Create backup plans
buplan_daily1week=$(aws backup create-backup-plan --cli-input-json file://awir-p-devops-bkp-daily1week.json --output text | awk '{print $2}')
buplan_dailymonthly1year=$(aws backup create-backup-plan --cli-input-json file://awir-p-devops-bkp-dailymonthly1year.json --output text | awk '{print $2}')
buplan_dailyweekly1month=$(aws backup create-backup-plan --cli-input-json file://awir-p-devops-bkp-dailyweekly1month.json --output text | awk '{print $2}')

###give a-ok to the impersonation of the role by backup.amazonaws.com
aws iam update-assume-role-policy --role-name awir-p-devops-iar-backup --policy-document file://policy_assumption.json

accountID=$(aws sts get-caller-identity --query "Account" --output text)

###for the resource assignation set the correct account ID for each account
sed -i "s/iam::.*:role/iam::$accountID:role/g" *.json

###Assign resources
sed -i "s/\"BackupPlanId\":.*,/\"BackupPlanId\":\"$buplan_daily1week\",/g" ra_daily1week.json
aws backup create-backup-selection --cli-input-json file://ra_daily1week.json
sed -i "s/\"BackupPlanId\":.*,/\"BackupPlanId\":\"$buplan_dailymonthly1year\",/g" ra_dailymonthly1year.json
aws backup create-backup-selection --cli-input-json file://ra_dailymonthly1year.json
sed -i "s/\"BackupPlanId\":.*,/\"BackupPlanId\":\"$buplan_dailyweekly1month\",/g" ra_dailyweekly1month.json
aws backup create-backup-selection --cli-input-json file://ra_dailyweekly1month.json
