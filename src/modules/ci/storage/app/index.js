const express = require('express')
const AzureStorageBlob = require("@azure/storage-blob");

require('dotenv').config()
const STORAGE_NAME = process.env.STORAGE_NAME
const SAS_TOKEN = process.env.SAS_TOKEN

const app = express()
const port = 3000

app.get('/api/storage/read/:blobName', (req, res) => {
  // const credential = new DefaultAzureCredential();
  const client = new BlobServiceClient(`https://${STORAGE_NAME}.blob.core.windows.net${SAS_TOKEN}`);
  const blobClient = containerClient.getBlobClient(req.params.blobName);
  const downloadBlockBlobResponse = await blobClient.download();
  const downloaded = (
    await streamToBuffer(downloadBlockBlobResponse.readableStreamBody)
  ).toString();
  console.log("Downloaded blob content:", downloaded);
  return "downloaded"
})

app.listen(port, () => {
  console.log(`Listening on port ${port}`)
})