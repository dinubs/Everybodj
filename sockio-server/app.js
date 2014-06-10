//require necessary modules
var http = require('http')
  , express = require('express')
  , socketIO = require("socket.io")
  , path = require('path');
var fs = require("fs");
//initialize our application
var app = express();
app.use(express.static(path.join(__dirname, 'assets')));
var server = http.createServer(app).listen(3000);
var io = socketIO.listen(server);

//settings
var settings = {
  'view_directory': '/views'
}


app.get('/', function(request, response){
  response.sendfile(__dirname + settings.view_directory + '/index.html')
});
app.get('/main', function(request, response){
	response.sendfile(__dirname + settings.view_directory + '/song/index.html');
});


//chat using socket.io
io.sockets.on('connection', function(client){
	var songs = fs.readdirSync("./assets/songs/");
	console.log(songs);
  //when client sends a join event
  client.on('join', function(data){
		io.emit('message', { message: songs + " just joined!", nickname: "Server Announcement" });
  });
	client.emit('message', songs);
	client.on("change_bg", function(data){
		console.log(data);
		
	});
	client.on("change_stroke", function(data){
		console.log(data);
		client.broadcast.emit("stroke", data);
 	});
	client.on("change_wave", function(data){
		client.broadcast.emit("change_wave", data);
 	});
});