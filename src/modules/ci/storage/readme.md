# Container Instances: Storage integration

This example demonstrate permissions for Container Instances to access Storage accounts.

There are two modes demonstrated here:
- Service Principal - To reduce the amount of credentials needed
- SAS Token - To restrict the time allowed for access via expiration dates

Create the resources:

```sh
terraform init
terraform apply -auto-approve
```

Upload the test blob to the container:

```sh
az storage blob upload -f 'file.txt' -c 'blobs' --account-name 'stawsomeaz104'
```

Generate the SAS token:

```sh
end=`date -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ'`

az storage account generate-sas --permissions 'acdfilprrtuwxy' --account-name 'stawsomeaz104' --services 'b' --resource-types 'sco' --expiry $end -o tsv
```

Add values to the `.env` file.

Start the server:

```sh
npm install
npm start
```

Local testing:

```sh
curl http://localhost:3000/api/sastoken
curl http://localhost:3000/api/managedidentity
```