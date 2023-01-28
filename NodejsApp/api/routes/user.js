import { Router } from "express";
const router = Router();
import { registerUser, loginUser, currentUser } from '../controllers/user/index.js';
import { upload } from '../../utils/multerUpload.js';

router.post("/",upload.single('profileImage'), registerUser);
router.post('/login',loginUser);
router.get('/data',currentUser);

export default router;