# Awsome AZ-104

A curated collection of AZ-104 certification statements accompanied by references and demos.

- **Statements** are derived from real exam questions
- **References** are the evidence for the statement
- **Demos** to see statements in action

Only statements that are directly related to exam questions are added to this collection.

## Azure Active Directory (AAD)

### New Tenant User Management

Existing AAD admins (Global Administrators, User Administrators, Owners) of an existing Tenant A must be added to a newly created Tenant B before they're able to manage users of that new Tenant B. The only user which will have instant management permissions is the administrator that created the new Tenant B.

Reference: [Add Users to Active Directory](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/add-users-azure-active-directory?view=azure-devops)

<details>
  <summary>Azure Portal Demo</summary>
  As we can see in this example, none of the existing users of Tenant A are added to the new Tenant B upon it's creation, with the exception of the Tenant B creator.

  <img src="demos/aad/aad_new_tenant_user_management.gif" width=650></img>
</details>

## Load Balancer (ILB, ELB)

### Load Balancer Permissions

