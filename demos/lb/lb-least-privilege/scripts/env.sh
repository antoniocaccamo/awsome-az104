export subscriptionId=$(az account show --query "id" --output tsv)
export group='rg-awsomeaz104-loadbalancer-permissions-demo'
export lbeName='lbe-awsomeaz104-loadbalancer-permissions-demo'
export lbiName='lbi-awsomeaz104-loadbalancer-permissions-demo'
