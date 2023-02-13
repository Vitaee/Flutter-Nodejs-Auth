import { favModel } from '../../models/favourites/index.js';
import errorJson from '../../../utils/error.js';
import jsonwebtoken from 'jsonwebtoken';

import * as dotenv from 'dotenv'
import mongoose from 'mongoose';
dotenv.config()

export default async (req,res) => {
  try {
        const PAGE_SIZE = 10;                   
        let skip;
    
        req.query.page ? skip = (req.query.page - 1) * PAGE_SIZE : skip = (1 - 1) * PAGE_SIZE;

        let str = req.get('authorization').split(" ")[1];
    
        const data =  jsonwebtoken.verify(str, process.env.JWT_SECRET_KEY );

        let favs = await favModel.find({"owner":mongoose.Types.ObjectId(data._id)}).populate('owner').sort( {_id: -1} ).skip( skip ).limit( PAGE_SIZE).catch( (e) => {
          console.log(e)
          console.log(e.message)
            return res.status(500).send(errorJson(e, 'An interval server error occurred while getting favs. from db.'))
        });

        favs.length >= 1 ? res.status(200).send( favs  ) : res.status(404).send([])

  } catch (err) {
    return res.status(500).send(errorJson(err, 'An interval server error occurred'))
  }
}