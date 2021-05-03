require('dotenv').config();
const JWT = require('jsonwebtoken');

module.exports = async (req,res) => {
    var str = req.get('authorization');
  try {
    const data = await JWT.verify(str, process.env.JWT_SECRET_KEY );
    console.log(data._id)
    // user datası return edilecek..
    res.send("Very Secret Data Oldu");
  } catch (err) {
    res.status(401);
    res.send("Bad Token");
  }
}