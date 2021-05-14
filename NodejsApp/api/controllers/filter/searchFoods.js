require('dotenv').config();
const MongoClient = require('mongodb').MongoClient;

module.exports = async (req,res) => {
  try {
      const dburl = 'mongodb://localhost:27017';
      const dbname = 'node-flutter';
      const collname = 'healthyFoods';

      MongoClient.connect(dburl, function (err, client) {
          if (!err) {
              const db = client.db(dbname);
              const collection = db.collection(collname);
              let regex = new RegExp(req.body.keyword, "i");

              collection.find({"food_name": regex}).toArray(function (err, results) {
                  results.length >= 1 ? res.status(200).send(results) : res.status(200).send({"msg":"Not found."})
              })
          }
          else res.send(err);

      });
  } catch (err) {
      console.log(err)
    res.status(401);
    res.send("Bad Token");
  }
}