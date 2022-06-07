# On-premises azcopy

You need to copy contents of a local folder `D:\folder1` to a public container an Azure Storage account.

Create the test resources:

```sh
az group create -n 'rg-azcopy' -l 'brazilsouth'
az storage account create -n 'stawsomeaz104' -g 'rg-azcopy' -l 'brazilsouth'
az storage container create -n 'public' --account-name 'stawsomeaz104' --public-access 'container'
```

Create the SAS token:

```sh
end=`date -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ'`

az storage account generate-sas --permissions 'acdfilprrtuwxy' --account-name 'stawsomeaz104' --services 'b' --resource-types 'sco' --expiry $end -o tsv
```

Create the test files (here in Windows):

```ps1
ni folder1/file1.txt -Force
ni folder1/folder2/file2.txt -Force
```

Copy the files:

```ps1
$token='<SAS Token>'

.\azcopy.exe copy "folder1" "https://stawsomeaz104.blob.core.windows.net/public?$token" --recursive
```

Destroy the resources after use:

```sh
az group delete -n 'rg-azcopy' -y
```