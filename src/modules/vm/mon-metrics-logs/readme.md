# Monitor Metrics and Logs of Linux VM

Monitoring of Metrics and Logs in a Linux VM can be performed by installing the [Linux Diagnostic Extension](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/diagnostics-linux?tabs=azcli) (LAD 4.0).

```sh
az vm create -n 'vm-az104' -g 'rg-az104' --image 'UbuntuLTS'
az storage account create -n 'stawsomeaz104' -g 'rg-az104' --sku 'Standard_LRS'
```

As demonstrated in the documentation:

```sh
az vm extension set \
  --publisher Microsoft.Azure.Diagnostics \
  --name LinuxDiagnostic \
  --version 4.0 \
  --resource-group 'rg-az104' \
  --vm-name 'vm-az104' \
  --protected-settings ProtectedSettings.json
```