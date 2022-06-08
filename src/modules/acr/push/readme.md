# Push Images to ACR

Assuming you have a local image build, how would you go about pushing it to ACR?

```sh
az acr create -n 'acrawsomeaz104' -g 'rg-az104' --sku 'Basic'
```

Build the sample image:

```sh
docker build -t alpine-mysqlclient .
```

To trigger a build and push it to ACR:

```sh
az acr build \
  --image 'alpine-mysqlclient' \
  --registry 'acrawsomeaz104' \
  --file Dockerfile .
```

You can also push a local image directly to ACR with `docker push` but you'll have to login to ACR beforehand using `docker login`.