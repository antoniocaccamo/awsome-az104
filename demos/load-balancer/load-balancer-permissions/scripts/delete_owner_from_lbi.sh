az role assignment delete --assignee $assignee \
--role 'Owner' \
--scope "/subscriptions/$subscriptionId/resourcegroups/$group/providers/Microsoft.Network/loadBalancers/$lbiName"
