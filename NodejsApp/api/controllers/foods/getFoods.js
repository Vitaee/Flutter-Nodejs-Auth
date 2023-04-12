import { foodModel } from '../../models/food/index.js';
import errorJson from '../../../utils/error.js';
import * as dotenv from 'dotenv'
dotenv.config()

export default async (req, res) => {
  try {
    const PAGE_SIZE = 4;
    const page = Number(req.query.page) || 1;
    const skip = (page - 1) * PAGE_SIZE;

    const pipeline = [
      {
        $sort: { _id: -1 },
      },
      {
        $skip: skip,
      },
      {
        $limit: PAGE_SIZE,
      },
    ];

    const foods = await foodModel.aggregate(pipeline).exec();

    return res.status(200).send(foods);
  } catch (err) {
    console.error(err);
    return res.status(500).send({ error: 'An interval server error occurred' });
  }
};