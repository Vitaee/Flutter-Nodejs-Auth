const express = require("express");
const router = express.Router();
const userController = require('../controllers/user');
const duplicateEmail = require("../middleware/auth/checkEmail");


router.post("/", [duplicateEmail],userController.register);
module.exports = router;