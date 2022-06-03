# Management Groups Permissions

For hands-on on these topics run the **[demo][2]**.

### Policy Inheritance

Policies applied to Management Groups and inherited by Subscriptions.

Let's consider the following configuration:

![Management Groups][1]

And the following policies applied:

| Policy | Resource | Applied To |
|--------|----------|------------|
|Not Allowed Resources Types | Virtual Networks | Tenant Root Group |
|Allowed Resources Types | Virtual Networks | ManagementGroup12 |

These operations are **not** allowed:

- Create a Virtual Network in Subscription1
- Create a Virtual Machine in Subscription2

### Adding Subscriptions

It is not possible to add subscription to more than one management group.

For example, giving the same scenario above, this command would fail:

```bash
az account management-group subscription add -n '<management-group-11>' -s 'Subscription1'
```


[1]: ../../assets/mg-permissions.png
[2]: https://github.com/epomatti/awsome-az104/tree/main/demos/mg/permissions