const express = require("express");
const router = express.Router();
const userController = require('../controllers/user');
const upload = require('../../utils/multerUpload');

router.post("/",userController.register);
router.post('/login',userController.login);
router.get('/data',userController.getUser);

router.post("/single", upload.single("image"), async (req, res) => {
    console.log(req.file);
  
    // uploading to AWS S3
    const result = await uploadFile(req.file);
    console.log("S3 response", result);
  
    // You may apply filter, resize image before sending to client
  
    // Deleting from local if uploaded in S3 bucket
    //await unlinkFile(req.file.path);
  
    res.send({
      status: "success",
      message: "File uploaded successfully",
      data: req.file,
    });
  });

module.exports = router;