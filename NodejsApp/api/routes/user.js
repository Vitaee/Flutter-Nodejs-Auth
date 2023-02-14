import { Router } from "express";
const router = Router();
import { registerUser, loginUser, currentUser } from '../controllers/user/index.js';
import { forgetPassword , resetPassword } from "../controllers/user/auth/forgotPass.js";
import multer from "multer";
const upload = multer({ storage: multer.memoryStorage() });

router.post("/",upload.single('profileImage'), registerUser);
router.post('/login',loginUser);
router.get('/data',currentUser);
router.post('/forgetPassword', forgetPassword);
router.put('/resetPassword/', resetPassword);

export default router;