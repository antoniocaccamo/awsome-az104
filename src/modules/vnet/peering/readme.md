# Peering

This example demonstrates that it is not possible to do VNET peering between overlapping CIDR addresses.

Based on the follow setup:

```sh
az group create -l 'brazilsouth' -n 'rg-az104'

az network vnet create -g 'rg-az104' -n 'VNet1' --address-prefixes '10.11.0.0/16'
az network vnet subnet create -g 'rg-az104' --vnet-name 'VNet1' -n 'internal' --address-prefixes '10.11.0.0/17'

az network vnet create -g 'rg-az104' -n 'VNet2' --address-prefixes '10.11.0.0/17'
az network vnet subnet create -g 'rg-az104' --vnet-name 'VNet1' -n 'internal' --address-prefixes '10.11.0.0/25'
```

It is not possible to peer the VNETs. This operation will fail.

```sh
az network vnet peering create -g 'rg-az104' -n 'peering' \
  --vnet-name 'VNet1' \
  --remote-vnet 'VNet2' \
  --allow-vnet-access
```