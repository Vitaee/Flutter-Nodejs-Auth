import jsonwebtoken from 'jsonwebtoken';
import { User } from '../../models/user/index.js';
import errorJson from '../../../utils/error.js';
import * as dotenv from 'dotenv'
dotenv.config()

export default async (req,res) => {
    let str = req.get('authorization').split(" ")[1];
  try {
    const data =  jsonwebtoken.verify(str, process.env.JWT_SECRET_KEY );

    let user =  await User.findById(data._id).catch((e) => {
      return res.status(500).json(errorJson(e, 'An interval server error occurred while getting your information, please try again.'))
    });

    res.status(200).send([{email:user.email, username:user.username, profileImage: user.profileImage, bio: user.bio}]);
    
  } catch (err) {
    res.status(401);
    res.send("Bad Token");
  }
}