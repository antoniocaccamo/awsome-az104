# Delete Resources

Demo showing that resources with active backups to Recovery Services vault need to be stopped from the back-up before the RSV can be deleted.

```sh
terraform init
terraform apply -auto-approve
```

> At of now only Windows VMs are supported for SQL Server backup-to-VM, and the the Guest Agent must be enabled.


Add the SQL database as a backup to VM in RSV (not available in azurerm provider):

[https://docs.microsoft.com/en-us/azure/backup/tutorial-sql-backup](https://docs.microsoft.com/en-us/azure/backup/tutorial-sql-backup)

After setting up the backup, try deleting the RSV:

```sh
 az backup vault delete --name 'rsv-rgv1' --resource-group 'RG26' --yes
```

Clean up the resources after you finish using them:

```sh
terraform destroy -auto-approve
```