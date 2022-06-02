# MG: Permissions

First create the sample tfvars file and add the required values:

```sh
cp example.tfvars .auto.tfvars
```

Create the "Subscription1" and "Subscription2" using the portal, or programmatically if your agreement allows it.

List the subscriptions IDs and add the values to the `.auto.tfvars` file.

```bash
# Add Subscription IDs to tvars
az account list

# Add Root Management Group to tfvars
az account management-group list
```

You might need to enable [elevated access][1].

[1]: https://docs.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin
