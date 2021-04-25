const {RateLimiterMongo} = require('rate-limiter-flexible');
const mongoose = require('mongoose');
const errorJson = require('../../utils/error');
require('dotenv').config();

const mongoOpts = {
    useCreateIndex: true,
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useFindAndModify: false
};

const mongoConn = mongoose.createConnection(process.env.DB,mongoOpts);

const opts = {
    storeClient:mongoConn,
    tableName:'rateLimits',
    points: 200,
    duration:60
}

module.exports = (req,res,next) => {
    const rateLimiterMongo = new RateLimiterMongo(opts);
    rateLimiterMongo.consume(req.ip)
        .then(() => {
            next();
        })
        .catch((err)=>{
            res.status(429).json(errorJson(err.message,'Too many request.'));
        });
};