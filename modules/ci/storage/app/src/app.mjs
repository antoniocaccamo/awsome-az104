import express from 'express';
import AzureStorageBlob from '@azure/storage-blob';
import 'dotenv/config';

(async function () {

  const STORAGE_NAME = process.env.STORAGE_NAME
  const SAS_TOKEN = process.env.SAS_TOKEN

  const app = express()
  const port = 3000

  app.get('/api/sastoken', async (req, res) => {
    // const credential = new DefaultAzureCredential();
    const client = new AzureStorageBlob.BlobServiceClient(`https://${STORAGE_NAME}.blob.core.windows.net?${SAS_TOKEN}`);
    const containerClient = client.getContainerClient("blobs");
    const blobClient = containerClient.getBlobClient("file.txt");
    const downloadBlockBlobResponse = await blobClient.download();
    const downloaded = (
      await streamToBuffer(downloadBlockBlobResponse.readableStreamBody)
    ).toString();
    console.log("Downloaded blob content:", downloaded);
    res.send(downloaded);
  })

  async function streamToBuffer(readableStream) {
    return new Promise((resolve, reject) => {
      const chunks = [];
      readableStream.on("data", (data) => {
        chunks.push(data instanceof Buffer ? data : Buffer.from(data));
      });
      readableStream.on("end", () => {
        resolve(Buffer.concat(chunks));
      });
      readableStream.on("error", reject);
    });
  }

  app.listen(port, () => {
    console.log(`Listening on port ${port}`)
  })

}());
