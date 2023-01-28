import { Router } from "express";
const router = Router();
import { getFoods, searchFood, scrapeFood } from '../controllers/foods/index.js';

router.get('/',getFoods);
router.post('/search', searchFood);
router.get('/scrape',scrapeFood);
export default router;