const Food = require('../../models/food');

module.exports = async (req,res) => {
  try {
      Food.find({"foodTitle": regex}).toArray(function (err, results) {
          results.length >= 1 ? res.status(200).send(results) : res.status(200).send({"msg":"Not found."})
        })
         
   } catch (err) {
      console.log(err)
    res.status(401);
    res.send("Unexpected Error");
  }
}