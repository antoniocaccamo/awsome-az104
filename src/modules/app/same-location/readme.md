# App and Plan need to be on same location

You cannot create a Web App in a location different from the Plan location.

```sh
az appservice plan create -g 'rg-az104' -n 'plan-az104' -l 'brazilsouth'

# There is no "location" argument, it must always follow the plan
az webapp create -g 'rg-az104' -p 'plan-az104' -n 'app-az104' -l 'eastus2'
```

