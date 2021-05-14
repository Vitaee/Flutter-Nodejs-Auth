const express = require("express");
const router = express.Router();
const foodController = require('../controllers/filter');

router.post('/',foodController.searchFood);
module.exports = router;