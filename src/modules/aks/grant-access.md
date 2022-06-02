# Grant access to AKS

As documented in [Kubernetes Authentication Strategies](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#authentication-strategies):

> Kubernetes uses client certificates, bearer tokens, or an authenticating proxy to authenticate API requests through authentication plugins.

And, as per Microsoft [Access and Identity](https://docs.microsoft.com/en-us/azure/aks/concepts-identity) docs:

> You can authenticate, authorize, secure, and control access to Kubernetes clusters in a variety of ways.
> 
> - Using Kubernetes role-based access control (Kubernetes RBAC), you can grant users, groups, and service accounts access to only the > resources they need.
> - With Azure Kubernetes Service (AKS), you can further enhance the security and permissions structure via Azure Active Directory and > Azure RBAC.

As we can see there are many options to grant access in AKS. Let's look into some examples below.

## Demo

For a hands-on experience, run the [demo](https://github.com/epomatti/awsome-az104/tree/main/demos/aks/grant-access) to create your environment and test these scenarios.

## RBAC

You can manage access using [AKS RBAC](https://docs.microsoft.com/en-us/azure/aks/manage-azure-rbac). This feature needs Managed AAD to be enabled in the AKS, along with enabling the RBAC feature itself.

```sh
az aks create -g 'MyResourceGroup' -n 'MyManagedCluster' --enable-aad --enable-azure-rbac
```

This has the advantage of granular permissions, such as applying different permissions to specific namespaces.

There are also some limitations to this approach, make sure to check the documentation.

### AAD Application Registration

Another form of authorization in Kubernetes is by creating an Application Registration on AAD and assigning permissions to that application to the AKS resource via IAM.

Although this works in practice, it is far less recommended to provide this tot end-users, and an RBAC approach would be much appropriate.

Snippet from the [docs](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens):

```
kubectl config set-credentials USER_NAME \
   --auth-provider=oidc \
   --auth-provider-arg=idp-issuer-url=( issuer url ) \
   --auth-provider-arg=client-id=( your client id ) \
   --auth-provider-arg=client-secret=( your client secret ) \
   --auth-provider-arg=refresh-token=( your refresh token ) \
   --auth-provider-arg=idp-certificate-authority=( path to your ca certificate ) \
   --auth-provider-arg=id-token=( your id_token )
```

### OIDC

Azure Kubernetes Services also can act as a OIDC issuer, which at the time of this writing is in Preview.

To see that running alongside [Azure Workload Identity](https://github.com/Azure/azure-workload-identity), checkout my other [repository](https://github.com/epomatti/azure-workload-identity-terraform).
