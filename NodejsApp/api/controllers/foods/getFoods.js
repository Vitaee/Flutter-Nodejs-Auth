const {Food} = require('../../models/food');
const errorJson = require('../../../utils/error');
require('dotenv').config();

module.exports = async (req,res) => {
  try {
        const PAGE_SIZE = 10;                   
        let skip;
    
        req.query.page ? skip = (req.query.page - 1) * PAGE_SIZE : skip = (1 - 1) * PAGE_SIZE;



        let foods = await Food.find().sort( {_id: -1} ).skip( skip ).limit( PAGE_SIZE).catch( (e) => {
            return res.status(500).errorJson(errorJson(e, 'An interval server error occurred while getting foods from db.'))
        });

        foods.length >= 1 ? res.status(200).send( foods  ) : res.status(404).send([])

  } catch (err) {
    return res.status(500).errorJson(errorJson(err, 'An interval server error occurred'))
  }
}