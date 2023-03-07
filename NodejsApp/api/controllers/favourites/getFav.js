import { favModel } from '../../models/favourites/index.js';
import * as dotenv from 'dotenv'
import mongoose from 'mongoose';
dotenv.config()

export default async (req, res) => {
  try {
    const PAGE_SIZE = 10;
    const page = req.query.page || 1;
    const skip = (page - 1) * PAGE_SIZE;

    const favs = await favModel.find({ owner: mongoose.Types.ObjectId(req.user._id) })
      .populate('owner')
      .sort({ _id: -1 })
      .skip(skip)
      .limit(PAGE_SIZE)
      .catch((e) => {
        console.error(e);
        return res.status(500).send({
          error: 'An internal server error occurred while getting favs from the database',
        });
      });

    return res.status(200).send({
      data: favs,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).send({
      error: 'An internal server error occurred',
    });
  }
};