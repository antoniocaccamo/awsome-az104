# Recreate Peering

This solution shows what to do when you add an address prefix for VNets already peered.

Considering the initial setup:

```sh
az group create -l 'brazilsouth' -n 'rg-az104'

az network vnet create -g 'rg-az104' -n 'VNet1' --address-prefixes '10.1.0.0/16'
az network vnet subnet create -g 'rg-az104' --vnet-name 'VNet1' -n 'MySubnet1' --address-prefixes '10.1.0.0/24'

az network vnet create -g 'rg-az104' -n 'VNet2' --address-prefixes '10.2.0.0/16'
az network vnet subnet create -g 'rg-az104' --vnet-name 'VNet2' -n 'MySubnet2' --address-prefixes '10.2.0.0/24'

az network vnet peering create -g 'rg-az104' -n 'VNet1-to-VNet2' \
  --vnet-name 'VNet1' \
  --remote-vnet 'VNet2' \
  --allow-vnet-access

az network vnet peering create -g 'rg-az104' -n 'VNet2-to-VNet1' \
  --vnet-name 'VNet2' \
  --remote-vnet 'VNet1' \
  --allow-vnet-access
```

If you try to add a CIDR prefix the request will fail:

> Address space of the virtual network {VNET ID} cannot change when virtual network has peerings.

```sh
az network vnet update -g 'rg-az104' -n 'VNet1' --address-prefixes '10.1.0.0/16' '10.33.0.0/16'
```

You need to **remove** the peering before being able to change VNet1, and re-creating the peerings afterwards.