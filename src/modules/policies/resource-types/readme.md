# Policy - Not Allowed Resource Types

The [Not Allowed Resources Policy](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2F6c112d4e-5bc7-47ae-a041-ea2d9dccd749) prevents resources to be created according to the scope and exclusion list.

Run the demo to test it quickly.

## Demo

### Setup

```sh
terraform init
terraform apply -auto-approve
```

### Execute

```sh
location='brazilsouth'

# This is allowed
az sql server create -l $location -g 'ContosoRG1' -n 'sql-awsomeaz104-testserver1' -u 'testAdmin' -p 'T3st4dminPazz!999'

# This is NOT allowed
az sql server create -l $location -g 'ContosoRG2' -n 'sql-awsomeaz104-testserver2' -u 'testAdmin' -p 'T3st4dminPazz!999'
```

---

Clean up after use:

```sh
az sql server delete -g 'ContosoRG1' -n 'sql-awsomeaz104-testserver1' -y
az sql server delete -g 'ContosoRG2' -n 'sql-awsomeaz104-testserver2' -y

terraform destroy -auto-approve
```
