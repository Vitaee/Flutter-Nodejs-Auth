const express = require("express");
const router = express.Router();
const userController = require('../controllers/user');


router.post("/",userController.register);
router.post('/login',userController.login);
router.get('/data',userController.getUser);
module.exports = router;