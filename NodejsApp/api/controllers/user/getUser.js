import errorJson from '../../../utils/error.js';
import * as dotenv from 'dotenv'
dotenv.config()

export default async (req,res) => {
  try {
    return res.status(200).send([{user: req.user}]);
  } catch (err) {
    return res.status(500).send(errorJson('An error accured!'))
  }
}