const express = require("express");
const router = express.Router();
require("express-async-errors");
const user = require("./user");

router.use('/user', user);

module.exports = router;