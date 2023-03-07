import { favModel } from '../../models/favourites/index.js';
import errorJson from '../../../utils/error.js';
import * as dotenv from 'dotenv'
dotenv.config()

export default async (req,res) => {
  try {
      let favs = await favModel.create({
            name: req.body.name,
            description: req.body.description,
            image: req.body.image,
            owner: req.user
      }).catch( (e) => {
            return res.status(500).errorJson(errorJson(e, 'An interval server error occurred while creating fav. item.'))
      });

      favs._id ? res.status(200).send( favs  ) : res.status(404).send([])

  } catch (err) {
    return res.status(500).errorJson(errorJson(err, 'An interval server error occurred'))
  }
}