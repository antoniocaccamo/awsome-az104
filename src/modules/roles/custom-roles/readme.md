# Custom Role

Exercise to create the following role:

- Can be assigned only to the resource groups in Subscription1
- Prevents the management of the access permissions for the resource groups
- Allows the viewing, creating, modifying, and deleting of resources within the resource groups

Create the role:

```sh
# Copy the template
cp sample-cr1.json cr1.json

# Replace the placeholder text with your subscription id
az account show --query 'id' -o tsv

# Create
az role definition create --role-definition '@cr1.json'
```

Content from [sample-cr1.json](sample-cr1.json):

```json
{{#include sample-cr1.json}}
```

Clean up after:

```sh
az role definition delete -n 'CR1'
```