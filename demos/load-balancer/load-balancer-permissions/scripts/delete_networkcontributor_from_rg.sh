az role assignment delete --assignee $assignee \
--role 'Network Contributor' \
--scope "/subscriptions/$subscriptionId/resourcegroups/$group"
