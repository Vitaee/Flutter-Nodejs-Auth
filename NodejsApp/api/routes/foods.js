const express = require("express");
const router = express.Router();
const foodController = require('../controllers/foods');

router.get('/',foodController.getFoods);
router.post('/search', foodController.searchFood);
router.get('/scrape',foodController.scrapeFood);
module.exports = router;