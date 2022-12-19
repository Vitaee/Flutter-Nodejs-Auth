const mongoose = require('mongoose');
require('dotenv').config();

const db = () => {
	mongoose.connect(process.env.DOCKER_DB,
			{
				useCreateIndex: true,
				useNewUrlParser: true,
				useUnifiedTopology: true,
				useFindAndModify: false
			}
		)
		.then(() => {
			console.log('Mongodb Connected Successfully');
		})
		.catch(err => {
			console.log("MongoDB Connection Error ==> " + err);
		});

	mongoose.Promise = global.Promise;
};

module.exports = { db };