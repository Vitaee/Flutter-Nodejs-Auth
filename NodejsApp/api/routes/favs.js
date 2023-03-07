import { Router } from "express";
const router = Router();
import { getFav, saveFav } from '../controllers/favourites/index.js';
import controlJwt from "../middleware/controlJwt.js";

router.get('/', controlJwt ,getFav);
router.post('/save', controlJwt ,saveFav);
export default router;