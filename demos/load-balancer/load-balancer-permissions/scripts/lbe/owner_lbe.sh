### Scenario 1

# Run as: Subscription Owner
az role assignment create --assignee $assignee \
  --role 'Owner' \
  --scope "/subscriptions/$subscriptionId/resourcegroups/$group/providers/Microsoft.Network/loadBalancers/$lbeName"

az role assignment list --assignee $assignee --all --query "[].roleDefinitionName"


# Run as: Admin1
az network lb address-pool create -g $group --lb-name $lbeName -n 'MyAddressPool_as_Owner'


# Run as: Subscription Owner
az role assignment delete --assignee $assignee \
  --role 'Owner' \
  --scope "/subscriptions/$subscriptionId/resourcegroups/$group/providers/Microsoft.Network/loadBalancers/$lbeName"
