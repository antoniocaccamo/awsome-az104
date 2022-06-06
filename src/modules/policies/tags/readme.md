# Policy: Apply Tags

This demo has a policy to [apply tags to resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies).

Rung the demo to see what happens when resources are created.

```sh
terraform init
terraform apply -auto-approve
```

```sh
az account show
subid='<....>'
az tag create --resource-id "/subscriptions/$subid/resourcegroups/RG6" --tags RGroup=RG6

az network vnet create -g 'RG6' -n 'VNET2'
```

---

Clean up after use:

```sh
az network vnet delete -g 'RG6' -n 'VNET2' -y

terraform destroy -auto-approve
```