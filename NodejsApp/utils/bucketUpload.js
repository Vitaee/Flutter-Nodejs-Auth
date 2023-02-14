import * as dotenv from 'dotenv'
dotenv.config();

import { User } from "../api/models/user/index.js"
import { S3 } from "@aws-sdk/client-s3";

const bucketName = process.env.AWS_BUCKET_NAME;
const region = process.env.AWS_BUCKET_REGION;
const accessKeyId = process.env.AWS_ACCESS_KEY;
const secretAccessKey = process.env.AWS_SECRET_KEY;

const s3 = new S3({
  region: region,
  credentials: {
    accessKeyId: accessKeyId,
    secretAccessKey: secretAccessKey
  }

});

// UPLOAD FILE TO S3
async function uploadFile(data) {
  const fileStream = Buffer.from(data.file.buffer);

  const uploadParams = {
    Bucket: bucketName,
    Body: fileStream,
    Key: data.file.originalname,
  };

  await s3.putObject(uploadParams);
  let profileImageUrl = `https://${bucketName}.s3.${region}.amazonaws.com/${data.file.originalname}`;

  await User.findByIdAndUpdate(data.userId, { profileImage: profileImageUrl });
  return { 'msg': 'Successfully updated profileImage!' };
}
export { uploadFile }