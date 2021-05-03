const {User} = require('../../models/user');
const errorJson = require('../../../utils/error');

require('dotenv').config();
const JWT = require('jsonwebtoken');

module.exports = async (req,res) => {
    var str = req.get('authorization');
  try {
    const data = await JWT.verify(str, process.env.JWT_SECRET_KEY );
    console.log(data._id)

    let user =  await User.findById(data._id).catch((e) => {
      return res.status(500).json(errorJson(e, 'An interval server error occurred while getting your information, please try again.'))
    });

    res.status(200).send(user);

    //res.send("Very Secret Data Oldu");
  } catch (err) {
    res.status(401);
    res.send("Bad Token");
  }
}