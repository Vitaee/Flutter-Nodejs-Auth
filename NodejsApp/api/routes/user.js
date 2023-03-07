import { Router } from "express";
import controlJwt from "../middleware/controlJwt.js";
import { registerUser, loginUser, currentUser } from '../controllers/user/index.js';
import { forgetPassword , resetPassword } from "../controllers/user/auth/forgotPass.js";
import multer from "multer";
const upload = multer({ storage: multer.memoryStorage() });
const router = Router();

router.post("/",upload.single('profileImage'), registerUser);
router.post('/login',loginUser);
router.get('/', controlJwt , currentUser);
router.post('/forgetPassword', forgetPassword);
router.put('/resetPassword/', resetPassword);

export default router;