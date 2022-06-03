# Managemt Group: Policies and Hierarchy

In this demo we'll demonstrate how policies are applied and inhrited by Subscriptions and controls when adding Subscriptions to Management Groups.

First create the sample tfvars file and add the required values:

```sh
cp example.tfvars .auto.tfvars
```

➡️ Create the "Subscription1" and "Subscription2" using the portal, or programmatically if your agreement allows it.

List the subscriptions IDs and add the values to the `.auto.tfvars` file.

```bash
# Add Subscription IDs to tvars
az account list

# Add Root Management Group to tfvars
az account management-group list
```
You might need to enable [elevated access][1].

After set up is complete connect to each subscription and try to run the scripts:

### Create VNet on Subscription1

Try to create a Virtual Network on Subscription1:

```bash
az account set --subscription 'Subscription1'

az group create -l 'brazilsouth' -n 'MyGroup'
az network vnet create -g 'MyGroup' -n 'MyVnet'
```

This command should fail.

### Create VM on Subscription2

Try to create a Virtual Network on Subscription2:

```bash
az account set --subscription 'Subscription2'

az group create -l 'brazilsouth' -n 'MyGroup'
az vm create -n 'MyVm' -g 'MyGroup' --image 'UbuntuLTS'
```

This command should also fail.

### Add Subscription1 to Group11

```bash
az account management-group subscription add -n '<management-group>' -s 'Subscription1'
```

This command will fail because Subscription1 is already part of a Management Group.

[1]: https://docs.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin
