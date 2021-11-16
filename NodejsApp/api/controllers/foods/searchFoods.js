const { Food } = require('../../models/food');

module.exports = async (req,res) => {
  try {
      const regex = new RegExp(req.body.title, 'i')
     
      const results = await Food.find({"food_title": {$regex: regex} })
        
      results.length >= 1 ? res.status(200).send(results) : res.status(200).send({"msg":"Not found."})
          
   } catch (err) {
      console.log(err)
    res.status(401);
    res.send("Unexpected Error");
  }
}