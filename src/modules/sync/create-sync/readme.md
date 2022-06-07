# Create Sync

This exercise will demonstrate the correct steps to Sync files from a cloud share to an on-premises server.

First create the base infrastructure required for the exercise, and then move to the steps required for the configuration of the file sync.

## Create the Base resources

> The _Storage Sync Service_ and the _File Share_ resources must be in the **same region**.

Create the File Share:

```sh
az group create -n 'rg-sync' -l 'brazilsouth'
az storage account create -n 'stawsomeaz104sync' -g 'rg-sync'
az storage share create --account-name 'stawsomeaz104sync' --name 'data'
```

Create the Storage Sync Service:

```sh
az storagesync create -g 'rg-sync' -n 'sync-awsomeaz104' -l "brazilsouth"
```

Create the Server VM:

```sh
az vm create \
    -g 'rg-sync' \
    -n'vm-sync' \
    --image 'Win2022Datacenter' \
    --public-ip-sku 'Standard' \
    --admin-username 'azureuser' \
    --admin-password 'SecretPassAz104!'
```

## Configure the Sync

This configuration required:
- Storage Account with a file share
- Storage Sync Service
- A Windows machine to run the File Sync Agent

Assuming you followed the steps above this should be ready.

### Step 1 - Install the Agent in the Server

Connect to the VM using RDP and `vm-sync\azureuser` and then [install the agent](https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-extend-servers#install-the-agent).


### Step 2 - Register the Server to the Storage Sync Service


Follow [these steps](https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-extend-servers#register-windows-server) for registration.


### Step 3 - Step Create the Sync Group

```sh
az storagesync sync-group create \
  -g 'rg-sync' \
  --storage-sync-service 'sync-awsomeaz104' \
  --name 'SampleSyncGroup'
```

### Step 4 - Add Cloud Endpoint

> The Cloud Endpoint must be added before the Server Endpoint

```sh
az storagesync sync-group cloud-endpoint create \
  --resource-group 'rg-sync' \
  --storage-sync-service 'sync-awsomeaz104' \
  --sync-group-name 'SampleSyncGroup' \
  --name "SampleCloudEndpoint" \
  --storage-account 'sync-awsomeaz104' \
  --azure-file-share-name 'data'
```

### Step 5 - Add Server Endpoint

```sh
az storagesync registered-server list --resource-group 'rg-sync' --storage-sync-service 'sync-awsomeaz104'

registeredServerId='<....>'

az storagesync sync-group server-endpoint create \
  --resource-group 'rg-sync' \
  --storage-sync-service 'sync-awsomeaz104' \
  --sync-group-name 'SampleSyncGroup' \
  --name 'SampleServerEndpoint' \
  --server-id $registeredServerId \
  --server-local-path "c:\abc"
```

You may wish to setup additional options for the Server Endpoint

```sh
  --cloud-tiering "off"
  --volume-free-space-percent 80
  --tier-files-older-than-days 20 \
  --offline-data-transfer "on"
  --offline-data-transfer-share-name "myfileshare"
```