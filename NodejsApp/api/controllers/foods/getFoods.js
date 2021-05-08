const mongoose = require('mongoose');
require('dotenv').config();
const MongoClient = require('mongodb').MongoClient;

module.exports = async (req,res) => {
  try {
      const dburl = 'mongodb://localhost:27017';
      const dbname = 'node-flutter';
      const collname = 'healthyFoods';

      MongoClient.connect(dburl, function (err, client) {
          if (!err) {

              // Get db
              const db = client.db(dbname);

              // Get collection
              const collection = db.collection(collname);

              // Find all documents in the collection
              collection.find({}).toArray(function (err, todos) {
                  res.status(200).send(todos);
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