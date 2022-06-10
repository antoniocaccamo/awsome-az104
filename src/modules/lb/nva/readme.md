# Balance to Network Virtual Appliance (NVA)

> HA Ports allow the LB to drop the ports and protocols requirements for balancing rules, forwarding all ports and protocols to the destination

> [Floating IP](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-floating-ip) = `enabled` means that the request will have the IP and Port replaced with LB name and port. If `disabled` (default), the IP and Ports will correspond to the destination.

To load balancer request for a Network Virtual appliance, HA ports are required:

- Internal-only
- Standard SKU

Must Internal + Standard to enable HA Ports.

And Floating IP must be `enabled` when creating the rule, so in case of multiple services responding to the same Port.

```sh
az network lb create -g 'rg-az104' -n 'lb-az104-standard' --sku 'Standard' --private-ip-address '10.0.0.x'
```
