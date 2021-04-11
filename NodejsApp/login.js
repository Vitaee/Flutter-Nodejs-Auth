var mysql = require('mysql');
var express = require('express');
var session = require('express-session');
var bodyParser = require('body-parser');
var path = require('path');
var bcrypt = require('bcrypt');


var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '123456',
    database: 'nodelogin',
});

var app = express();
var PORT = 3000;
app.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: true
}));

app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

// Error handling
app.use(function (req,res,next){
    res.setHeader("Acces-Control-Allow-Origin","*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
     res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
     res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Origin,Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers,Authorization");
   next();
})


// Api functions.
app.post('/regis',function(request, response){
	const username = request.body.username
	var password = request.body.password
	const email = request.body.email
	bcrypt.hash(password,10, function(err, hash) {

		var r_user = {
			"username":username,
			"password":hash,
			"email":email
		}
	
		connection.query('INSERT INTO accounts SET ?', r_user, function(error, results, fields){
			if (error){
				response.send('Unexpected error while registering user. Please try again.')
			}else{
				request.session.loggedin = true;
				//request.session.username = username;
				response.send({"status":200,"username":request.session.username,
					"email":request.session.email})
				//response.redirect('/home');
	
				response.end();
			}
		});

	});

	
	
});

app.post('/auth', function(request, response) {
	var username = request.body.username;
	var password = request.body.password;

	if (username && password) {
		connection.query('SELECT * FROM accounts WHERE `username` = ?', [username], async function(error, results, fields) {
			if (results.length > 0) {
				const comparision = await bcrypt.compare(password, results[0].password)
				if(comparision){
					

					//response.redirect('/home');
					response.send({'status':200, 'username':results[0].username, 'email':results[0].email, 'loggedin':true})
					response.end();


				}else {
					response.send('Wrong username / password!');
					response.end();
				}
				
			}else{
				response.send('Wrong username or password!');
				response.end();
			}

		});
	} else {
		response.send('Please enter Username and Password!');
		response.end();
	}
});


//app.listen(3000);
app.listen(PORT, (req, res) => {
    console.log(`Server is running on ${PORT} port.`);
})