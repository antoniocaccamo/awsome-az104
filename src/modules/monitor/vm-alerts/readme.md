# Create Alert for VM

Create the base resources:

```sh
az group create -n 'rg-az104' -l 'brazilsouth'

az storage account create -n 'stawsomeaz104' -g 'rg-az104' -l 'brazilsouth'

az vm create \
  -g 'rg-az104' \
  -n'vm-az104' \
  --image 'Win2022Datacenter' \
  --public-ip-sku 'Standard' \
  --admin-username 'azureuser' \
  --admin-password 'SecretPassAz104!' \
  --enable-agent

az monitor log-analytics workspace create -g 'rg-az104' -n 'log-az104' -l 'eastus2'
```

1. Configure Guest-Level monitoring in the VM via the Portal.
2. Enable Log Analytics in the VM (via Diagnostic Settings)
4. Add "System" in Log Analytics in the Agent Manager blade. MicrosoftMonitoringAgent should be already installed in the image. (You **DO NOT** "add" the agent from the Marketplace. It is installed)

You can now create a custom Alert in Azure Monitor.
