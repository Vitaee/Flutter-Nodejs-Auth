import express from 'express';
import morgan from 'morgan';
import { db } from './api/middleware/db.js';
import errorJson from './utils/error.js';
import rateLimiter from './api/middleware/rateLimiter.js';
import Routes from './api/routes/index.js';
import path from 'path';
import * as dotenv from 'dotenv'
dotenv.config()

const app = express();

process.on('uncaughtException', (error) => {
	console.log(error);
});

process.on('unhandledRejection', (ex) => {
	console.log(ex);
});

const PORT = process.env.port || 3000;

app.use(morgan('dev'));
app.use(rateLimiter);

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.set('trust proxy', true);
db();

app.get('/', (req, res) => {
	res.status(200).json({resultMessage: 'Our App is successfully working...'});
});


app.use((error,req,res,next) =>{
	res.status(error.status || 500);
	if (res.status === 500){
		res.json({
			resultMessage:{msg: error.messagge}
		})
	}else if(error.status === 404){
		res.json({
			resultMessage:{msg:error.messagge}
		})
	}else {
		console.log("Unexpected Error")
		
	}
});


app.use('/', Routes);


app.use((req, res, next) => {
	res.header('Access-Control-Allow-Origin', '*');
	res.header('Access-Control-Allow-Headers',
		'Origin, X-Requested-With, Content-Type, Accept, Authorization');
	res.header('Content-Security-Policy-Report-Only', 'default-src: https:');
	if (req.method === 'OPTIONS') {
		res.header('Access-Control-Allow-Methods', 'PUT POST PATCH DELETE, GET');
		return res.status(200).json({});
	}
	next();

});



app.get('/resetPassword/:token/', (req,res) => {
	const __dirname = path.dirname(new URL(import.meta.url).pathname);

	res.sendFile(path.join(__dirname+'/resetPass.html'));
})

app.listen(PORT, () => console.log(`Server is running on ${PORT}`));
