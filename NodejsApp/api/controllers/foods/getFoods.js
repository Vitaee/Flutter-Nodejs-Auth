const {Food} = require('../../models/food');
const errorJson = require('../../../utils/error');
require('dotenv').config();

module.exports = async (req,res) => {
  try {
    let foods = await Food.find().sort({length: -1}).limit(15).catch( (e) => {
        return res.status(500).errorJson(errorJson(e, 'An interval server error occurred while getting foods from db.'))
    });

    res.status(200).send( {data: foods } )

  } catch (err) {
    return res.status(500).errorJson(errorJson(err, 'An interval server error occurred'))
  }
}