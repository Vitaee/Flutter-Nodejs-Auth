import mongoose from 'mongoose';
import * as dotenv from 'dotenv'
dotenv.config()
const db = () => {
	mongoose.connect(process.env.DB,
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

export { db };