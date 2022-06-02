# Load Balancer Least Privilege Permissions

For an administrator to be able to create Backend Pools on ELBs and Health Probes on ILBs the minimum permission that they'll need is `Network Contributor` on those resources AND in the Virtual Network.

**[Run the Demo](https://github.com/epomatti/awsome-az104/tree/main/demos/lb/lb-least-privilege)**

The reason being that a change on the subnet is also required, as demonstrated in the following exception.

```
Message: The client 'Admin1@yourdomain.onmicrosoft.com' with object id '00000' has permission to perform action 'Microsoft.Network/loadBalancers/write' on scope '/subscriptions/00000/resourceGroups/rg-awsomeaz104-loadbalancer-permissions-demo/providers/Microsoft.Network/loadBalancers/lbi-awsomeaz104-loadbalancer-permissions-demo'; however, it does not have permission to perform action 'Microsoft.Network/virtualNetworks/subnets/join/action' on the linked scope(s) '/subscriptions/00000/resourceGroups/rg-awsomeaz104-loadbalancer-permissions-demo/providers/Microsoft.Network/virtualNetworks/vnet-awsomeaz104-loadbalancer-permissions-demo/subnets/LBI-Subnet' or the linked scope(s) are invalid.
```

In the experiment the following output was reproduced, this of course given that the Virtual Network resides on the same Resource Group.

| Target | Assignment | Scope | Action | Result | Least <br> Privilege | 
|------------|-------|--------|--------|:-:|:-----------------:|
| ELB | Contributor | External Load Balancer | Add Backend Pool | ❌ | ❌ |
| ELB | Network Contributor | External Load Balancer | Add Backend Pool | ❌ | ❌ |
| ELB | Network Contributor | Resource Group | Add Backend Pool | ✅ | ✅ |
| ELB | Owner | External Load Balancer | Add Backend Pool | ❌ | ❌ |
| ILB | Contributor | Internal Load Balancer | Add Health Probe | ❌ | ❌ |
| ILB | Network Contributor | Internal Load Balancer | Add Health Probe | ❌ | ❌ |
| ILB | Network Contributor | Resource Group | Add Health Probe | ✅ | ✅ |
| ILB | Owner | Internal Load Balancer | Add Health Probe | ❌ | ❌ |