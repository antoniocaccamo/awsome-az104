az role assignment create --assignee $assignee \
--role 'Network Contributor' \
--scope "/subscriptions/$subscriptionId/resourcegroups/$group/providers/Microsoft.Network/loadBalancers/$lbiName"
