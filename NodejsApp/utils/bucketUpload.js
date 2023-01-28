import { S3Client, PutObjectCommand, GetObjectCommand } from "@aws-sdk/client-s3";
//const{ getSignedUrl } = require("@aws-sdk/s3-request-presigner");
import { createReadStream } from "fs";
import {  deleteSync } from 'del';
import * as dotenv from 'dotenv'
dotenv.config()
import { existsSync, mkdirSync } from "fs";


const bucketName = process.env.AWS_BUCKET_NAME;
const region = process.env.AWS_BUCKET_REGION;
const accessKeyId = process.env.AWS_ACCESS_KEY;
const secretAccessKey = process.env.AWS_SECRET_KEY;

const s3 = new S3Client({
  region: region,
  credentials: {
    accessKeyId: accessKeyId,
    secretAccessKey: secretAccessKey
  }

});

// UPLOAD FILE TO S3
async function uploadFile(file) {
  
  let dir = "./public/images";
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }
  
  const fileStream = createReadStream(file.path);

  const uploadParams = {
    Bucket: bucketName,
    Body: fileStream,
    Key: file.filename,
  };

  await s3.send(new PutObjectCommand(uploadParams));

  deleteSync(['public/*/']);
  /*const command = new GetObjectCommand({
    Bucket: bucketName,
    Key: file.filename,
  });

  const url = await getSignedUrl(s3, command);*/

  return `https://${bucketName}.s3.${region}.amazonaws.com/${file.filename}`;
}


export { uploadFile }