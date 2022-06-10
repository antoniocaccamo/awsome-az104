# Application Security Group

Granted you have a VM and an NSG, how to apply an Application Security Group?

```sh
az vm create -n 'vm-az104' -g 'rg-az104' --image 'UbuntuLTS'

az network asg create -g 'rg-az104' -n 'asg-az104'
```

The ASG is applied directly to the NIC:

```sh
az network nic ip-config update -n 'ipconfigvm-az104' -g 'rg-az104' --nic-name 'vm-az104VMNic' --application-security-groups 'asg-az104'
```
