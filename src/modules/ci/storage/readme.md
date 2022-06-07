# Container Instances: Storage integration



Generate the SAS token:

```
```sh
end=`date -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ'`

az storage account generate-sas --permissions 'acdfilprrtuwxy' --account-name 'stawsomeaz104' --services 'b' --resource-types 'sco' --expiry $end -o tsv
```
```