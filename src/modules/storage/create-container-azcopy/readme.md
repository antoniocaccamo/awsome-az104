# Create a container with azcopy

Use the `make` option in azcopy to create a container.

```sh
az group create -n 'rg-azcopy-vmimage' -l 'brazilsouth'
az storage account create -n 'stawsomeaz104' -g 'rg-azcopy-vmimage'

end=`date -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ'`
az storage account generate-sas --permissions 'acdfilprrtuwxy' --account-name 'stawsomeaz104' --services 'b' --resource-types 'sco' --expiry $end -o tsv
```

Using PowerShell:

```ps1
.\azcopy.exe make "https://stawsomeaz104.blob.core.windows.net/vmimages?$token"
```
