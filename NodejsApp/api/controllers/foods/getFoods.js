import { foodModel } from '../../models/food/index.js';
import errorJson from '../../../utils/error.js';
import * as dotenv from 'dotenv'
dotenv.config()

export default async (req,res) => {
  try {
        const PAGE_SIZE = 10;                   
        let skip;
    
        req.query.page ? skip = (req.query.page - 1) * PAGE_SIZE : skip = (1 - 1) * PAGE_SIZE;

        let foods = await foodModel.find().sort( {_id: -1} ).skip( skip ).limit( PAGE_SIZE).catch( (e) => {
            return res.status(500).send(errorJson(e, 'An interval server error occurred while getting foods from db.'))
        });

        foods.length >= 1 ? res.status(200).send( foods  ) : res.status(404).send([])

  } catch (err) {
    return res.status(500).send(errorJson(err, 'An interval server error occurred'))
  }
}