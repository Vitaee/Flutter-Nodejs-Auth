import { Router } from "express";
const router = Router();
import "express-async-errors";
import user from "./user.js";
import foods from './foods.js';
import favs from "./favs.js";

router.use('/user', user);
router.use('/favs', favs);
router.use('/foods', foods);
export default router;