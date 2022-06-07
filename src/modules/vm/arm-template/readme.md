# ARM Template

Create a VM using ARM template for both **PowerShell** and **Azure CLI**.

### Create the Resource Group

For this example you create the resource group separately (or reuse one you have).

```ps1
# PowerShell
Connect-AzAccount
New-AzResourceGroup -Name "rg-vm"-Location "brazilsouth"
```

```bash
# Azure CLI
az login
az group create --name "rg-vm" --location "brazilsouth"
```

### Create the Group Deployment

```ps1
# PowerShell
New-AzResourceGroupDeployment `
  -Name DeployLocalTemplate `
  -ResourceGroupName "rg-vm" `
  -TemplateFile "@azuredeploy.json" `
  -TemplateParameterFile '@azuredeploy-parameters.json'
  -verbose
```

```bash
# Azure CLI
az deployment group create \
  --name DeployLocalTemplate \
  --resource-group 'rg-vm' \
  --template-file '@azuredeploy.json' \
  --parameters '@azuredeploy-parameters.json'
  --verbose
```