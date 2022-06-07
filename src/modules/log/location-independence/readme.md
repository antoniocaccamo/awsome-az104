# Location Independence

This example demonstrate a Log Analytics workspace being attached to resources that are not part of the same location.

Create the base resources:

```sh
az group create -n 'rg-az104' -l 'brazilsouth'
az storage account create -n 'stawsomeaz104' -g 'rg-az104' -l 'brazilsouth'
az backup vault create -l 'brazilsouth' --name 'rsv-az104' -g 'rg-az104'

az monitor log-analytics workspace create -g 'rg-az104' -n 'log-az104' -l 'eastus2'
```

Add the RSV from one location to a Log Analytics Workspace from another location:

```sh
id=$(az backup vault show -n 'rsv-az104' -g 'rg-az104' --query id -o tsv)

az monitor diagnostic-settings create --resource $id -n 'rsv-reports' \
  --storage-account 'stawsomeaz104' \
  --logs '[
    {
      "category": "AzureBackupReport",
      "enabled": true,
      "retentionPolicy": {
        "enabled": false,
        "days": 0
      }
    }
  ]' 
```