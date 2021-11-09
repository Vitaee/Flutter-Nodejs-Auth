const express = require("express");
const router = express.Router();
require("express-async-errors");
const user = require("./user");
const foods = require('./foods');

router.use('/user', user);
router.use('/foods', foods);
module.exports = router;