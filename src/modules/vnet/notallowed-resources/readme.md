# Virtual Network Policies

This example demonstrates the following behaviors with VNET policies:
- Can't move resources where the Not Allowed Resource Types match
- Policies do not change resources states once they are created, only compliance alerts
- 

To test it, create the base resources:

```sh
terraform init
terraform apply -auto-approve
```

Once done, try executing the following commands.

You'll see that both tasks are prohibited by the policy.


```sh
# validate / move VNET1 to RG2
vnet1=$(az resource show -g 'RG1' -n 'VNET1' --resource-type "Microsoft.Network/virtualNetworks" --query id --output tsv)
az resource move --destination-group 'RG2' --ids $vnet1

# Change VNET prefix
az vm delete -g 'VNET2' -n 'VM1' --yes
az network vnet subnet delete --name 'internal' --resource-group 'RG2' --vnet-name 'VNET2'
az network vnet update --address-prefixes '40.1.0.0/24' -n 'VNET2' -g 'RG2'
```