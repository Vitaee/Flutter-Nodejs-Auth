const express = require("express");
const router = express.Router();
const foodController = require('../controllers/foods');

router.get('/',foodController.getFoods);
module.exports = router;