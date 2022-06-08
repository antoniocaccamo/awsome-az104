# Manage VMs

To manage the consistency of Virtual Machines with Automation State Configuration, the following steps are executed.

Considering that the VMs are already onboarded into the Automation Account:

1. Upload a configuration to Automation Account in the blade State Configuration (DSC)
2. Compile the configuration and add it to a node (VM)
3. Check the compliance status

#### Demonstration

Create the resorces

```
az automation account create --automation-account-name 'aa-az104' -g 'rg-az104'
az vm create -n 'az-104' -g 'rg-az104' --image UbuntuLTS
```

Run the configuration manually as in the official [tutorial](https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started).