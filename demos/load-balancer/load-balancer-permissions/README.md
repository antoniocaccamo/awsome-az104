# Demo: Load Balancer Permissions

Create the infrastructure: 

```bash
terraform init
terraform apply -auto-approve
```
This will create LB1 (Internal) and LB2 (External), along with a user `Admin1` without any permissions yet.

From the Terraform output, set the `Admin1` object id: 

```bash
export assignee='<ADMIN1_OBJECT_ID>'
```

Set the common variables:

```bash
source scripts/env.sh
```

To test and list `Admin1` all current assignments:

```bash
az role assignment list --assignee $assignee --all
```

## Commands

From the folder [scripts](scripts) create and remove the permissions to run the tests:

Example:

```bash
bash scripts/create_contributor_to_lbi.sh

bash scripts/delete_contributor_from_lbi.sh
```