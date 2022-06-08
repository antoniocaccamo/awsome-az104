# Extension Profile

As demonstrated by the existing [azuredeploy_v2](https://github.com/Azure-Samples/compute-automation-configurations/blob/master/scale_sets/azuredeploy_v2.json) example, to deploy a Scale Set for Windows machines while having the possibility to add apps such as Web components:

1. Upload the script file
2. Modify the `extensionProfile` in the ARM template

Snippet from Microsoft [documentation](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-install-apps-template):

```json
"extensionProfile": {
  "extensions": [
    {
      "name": "AppInstall",
      "properties": {
        "publisher": "Microsoft.Azure.Extensions",
        "type": "CustomScript",
        "typeHandlerVersion": "2.0",
        "autoUpgradeMinorVersion": true,
        "settings": {
          "fileUris": [
            "https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate_nginx_v2.sh"
          ],
          "commandToExecute": "bash automate_nginx_v2.sh"
        }
      }
    }
  ]
}
```

These can also be configured using Azure CLI:

```sh
az vmss extension set --vmss-name my-vmss --name customScript --resource-group my-group \
  --version 2.0 --publisher Microsoft.Azure.Extensions \
  --provision-after-extensions NetworkWatcherAgentLinux VMAccessForLinux  \
  --settings '{"commandToExecute": "echo testing"}'
```