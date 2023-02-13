import { favModel } from '../../models/favourites/index.js';
import { User } from '../../models/user/index.js';
import jsonwebtoken from 'jsonwebtoken';
import errorJson from '../../../utils/error.js';

import * as dotenv from 'dotenv'
dotenv.config()

export default async (req,res) => {
  try {
      let str = req.get('authorization').split(" ")[1];
    
      const data =  jsonwebtoken.verify(str, process.env.JWT_SECRET_KEY );

      let user =  await User.findById(data._id).catch((e) => {
          return res.status(500).json(errorJson(e, 'An interval server error occurred while getting your information, please try again.'))
      });

      let favs = await favModel.create({
            name: req.body.name,
            description: req.body.description,
            image: req.body.image,
            owner: user
      }).catch( (e) => {
            return res.status(500).errorJson(errorJson(e, 'An interval server error occurred while creating fav. item.'))
      });

      favs._id ? res.status(200).send( favs  ) : res.status(404).send([])

  } catch (err) {
    return res.status(500).errorJson(errorJson(err, 'An interval server error occurred'))
  }
}