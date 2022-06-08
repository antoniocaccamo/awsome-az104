# Provision Scale Set with cloud-init

Simply add a file via `--custom-data` with the custom code:

```sh
az vmss create \
  -n 'vmss-az104' \
  -g 'rg-az104' \
  --instance-count 1 \
  --image 'Win2022Datacenter' \
  --custom-data '@clout-init.txt' \
  --admin-username 'azureuser' \
  --admin-password 'SecretPassAz104!'
```

Example with [cloud-init](https://cloudbase-init.readthedocs.io/en/latest/index.html):

```
{{#include cloud-init.txt}}
```
