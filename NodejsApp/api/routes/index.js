const express = require("express");
const router = express.Router();
require("express-async-errors");
const user = require("./user");
const foods = require('./foods');
const filter = require('./filter');

router.use('/user', user);
router.use('/foods', foods);
router.use('/search', filter);
module.exports = router;