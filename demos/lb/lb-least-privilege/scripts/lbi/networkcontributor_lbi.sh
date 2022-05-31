### Scenario 1

# Run as: Subscription Owner
az role assignment create --assignee $assignee \
--role 'Network Contributor' \
--scope "/subscriptions/$subscriptionId/resourcegroups/$group/providers/Microsoft.Network/loadBalancers/$lbiName"

az role assignment list --assignee $assignee --all --query "[].roleDefinitionName"


# Run as: Admin1
az network lb probe create -g $group --lb-name $lbiName -n 'MyProbe_as_NetworkContributor' \
  --protocol 'http' --port 80 --path '/'

# Run as: Subscription Owner
az role assignment delete --assignee $assignee \
--role 'Network Contributor' \
--scope "/subscriptions/$subscriptionId/resourcegroups/$group/providers/Microsoft.Network/loadBalancers/$lbiName"
