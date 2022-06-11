# Reverse DNS

Discover the VM DNS name with reverse DNS.

Create a VM:

```sh
az vm create -n 'vm-az104' -g 'rg-az104' --image 'UbuntuLTS' --admin-user 'azureuser' --admin-password 'AwsomeAz104!'
```

Connect to it and run the command:

```sh
dig -x 10.0.0.4 +short
```

The response will be: `vm-az104.internal.cloudapp.net.`
