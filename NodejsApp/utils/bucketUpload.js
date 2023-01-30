import { S3Client, PutObjectCommand, GetObjectCommand } from "@aws-sdk/client-s3";
//const{ getSignedUrl } = require("@aws-sdk/s3-request-presigner");
import { createReadStream } from "fs";
import {  deleteSync } from 'del';
import * as dotenv from 'dotenv'
dotenv.config()
import { existsSync, mkdirSync } from "fs";
import { User } from "../api/models/user/index.js"


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
async function uploadFile(data) {
  
  let dir = "./public/images";
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }
  
  const fileStream = createReadStream(data.file.path);

  const uploadParams = {
    Bucket: bucketName,
    Body: fileStream,
    Key: data.file.filename,
  };

  await s3.send(new PutObjectCommand(uploadParams));
  let profileImageUrl = `https://${bucketName}.s3.${region}.amazonaws.com/${data.file.filename}`;

  deleteSync(['public/images/*/']);
  await User.findByIdAndUpdate( data.userId, {profileImage: profileImageUrl })
  return {'msg' : 'Successfully updated profileImage!'} 
}


export { uploadFile }