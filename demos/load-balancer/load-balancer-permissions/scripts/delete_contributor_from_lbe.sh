az role assignment delete --assignee $assignee \
--role 'Contributor' \
--scope "/subscriptions/$subscriptionId/resourcegroups/$group/providers/Microsoft.Network/loadBalancers/$lbeName"
