az role assignment create --assignee $assignee \
--role 'Contributor' \
--scope "/subscriptions/$subscriptionId/resourcegroups/$group/providers/Microsoft.Network/loadBalancers/$lbiName"
