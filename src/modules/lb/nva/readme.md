# Balance to Network Virtual Appliance (NVA)

> HA Ports allow the LB to drop the ports and protocols requirements for balancing rules, forwarding all ports and protocols to the destination

> Floating IP = `enabled` means that the request will have the IP and Port replaced with the destination VM. If `disabled` (default), the IP and Ports will correspond to the LB frontend.

To load balancer request for a Network Virtual appliance, HA ports are required:

- Internal-only
- Standard SKU

Must Internal + Standard to enable HA Ports.

```sh
az network lb create -g 'rg-az104' -n 'lb-az104-standard' --sku 'Standard' --private-ip-address '10.0.0.x'
```
