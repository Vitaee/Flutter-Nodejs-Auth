require("dotenv").config();
const {S3Client, PutObjectCommand} = require("@aws-sdk/client-s3");
const fs = require("fs");

const bucketName = process.env.AWS_BUCKET_NAME;
const region = process.env.AWS_BUCKET_REGION;
const accessKeyId = process.env.AWS_ACCESS_KEY;
const secretAccessKey = process.env.AWS_SECRET_KEY;

const s3 = new S3Client({
  region: "us-east-1",
  accessKeyId: accessKeyId,
  secretAccessKey: secretAccessKey
});

// UPLOAD FILE TO S3
async function uploadFile(file) {
  const fileStream = fs.createReadStream(file.path);

  const uploadParams = {
    Bucket: "awsbucketvitae",
    Body: fileStream,
    Key: file.filename,
  };



  const data = await s3.send(new PutObjectCommand(uploadParams));
  return data;
}


module.exports = { uploadFile };