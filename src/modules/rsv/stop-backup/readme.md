# Stop Backup

This example demonstrate that it is necessary to stop VM backups before it is allowed to an RSV to be deleted.

```sh
az group create -n 'rg-az104' -l 'brazilsouth'
az backup vault create -l 'brazilsouth' --name 'rsv-az104' -g 'rg-az104'
az vm create -n 'vm-az104' -g 'rg-az104' --image 'UbuntuLTS'
```

Enable the backup for the VM:

```sh
az backup protection enable-for-vm \
  --resource-group 'rg-az104' \
  --vault-name 'rsv-az104' \
  --vm 'vm-az104' \
  --policy-name DefaultPolicy
```

Now create the first backup:

```sh
az backup protection backup-now \
  --container-name 'iaasvmcontainerv2;rg-az104;vm-az104' \
  --item-name 'vm-az104' \
  --resource-group 'rg-az104' \
  --retain-until '01-02-2025' \
  --vault-name 'rsv-az104' \
  --backup-management-type 'AzureIaasVM'
```

If you try to delete the RSV it will not be allowed:

```sh
az backup vault delete --name 'rsv-az104' -g'rg-az104' --yes
```

The first step to permit RSV deletion is to stop backup on the items:

```sh
az backup protection disable \
  --container-name 'iaasvmcontainerv2;rg-az104;vm-az104' \
  --backup-management-type 'AzureIaasVM' \
  --delete-backup-data false \
  --item-name 'vm-az104' \
  --resource-group 'rg-az104' \
  --vault-name 'rsv-az104' --yes
```

If backup items exist, they should be unregistered before the RSV can be deleted.

```sh
az backup container unregister --container-name 'iaasvmcontainerv2;rg-az104;vm-az104' -g 'rg-az104' --vault-name 'rsv-az104' --backup-management-type 'AzureIaasVM'
```
