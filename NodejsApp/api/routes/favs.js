import { Router } from "express";
const router = Router();
import { getFav, saveFav } from '../controllers/favourites/index.js';

router.get('/',getFav);
router.post('/save', saveFav);
export default router;