# Resource Locks

Different behaviors when moving resources, varying according to the Lock types.

Create the base resources state:

```sh
az group create -n 'RG1' -l 'westeurope'
az group create -n 'RG2' -l 'westeurope'
az group create -n 'RG3' -l 'eastus'

az storage account create -n 'stawsomeaz104' -g 'RG1'

az lock create --name 'Read Only' --resource-group 'RG2' --lock-type 'ReadOnly'
az lock create --name 'Can Not Delete' --resource-group 'RG3' --lock-type 'CanNotDelete'
```

Try moving the resources:

```sh
storage=$(az resource show -g 'RG1' -n 'stawsomeaz104' --resource-type "Microsoft.Storage/storageAccounts" --query id --output tsv)

# No, this will NOT be allowed
az resource move --destination-group 'RG2' --ids $storage

# Yes, this WILL be allowed
az resource move --destination-group 'RG3' --ids $storage
```