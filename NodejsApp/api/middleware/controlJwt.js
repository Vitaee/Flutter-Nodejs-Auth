import jsonwebtoken from 'jsonwebtoken';
import { User } from '../models/user/index.js';

export default async (req, res, next) => {
    let token = req.get('authorization')
    let data = "";
    if (token) {
        
        token = token.split(" ")[1];
        try{
            data = jsonwebtoken.verify(token, process.env.JWT_SECRET_KEY)
        }catch (e) {
            return res.status(401).send({error: 'Bad token provided!'})
        }
            req.user = await User.findById(data._id);
        
        next();

    } else {
        return res.status(400).send({
            error: 'Authorization header is missing',
          });
    }
}