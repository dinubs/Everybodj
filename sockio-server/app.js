//require necessary modules
var http = require('http'),
    express = require('express'),
    path = require('path');

//initialize our application
var app = express();

app.use(express.static(path.join(__dirname, 'assets')));
var server = http.createServer(app).listen(process.env.PORT || 8000);
console.log(process.env.PORT);


app.get('/android', function(request, response){
  response.sendfile(__dirname + "/views" + '/index.html');
});
app.get('/', function(request, response){
	response.sendfile(__dirname + "/views" + '/song/index.html');
});
app.get('/index.html', function(request, response){
  response.sendfile(__dirname + "/views" + '/song/index.html');
});