//require necessary modules
var http = require('http')
  , express = require('express')
  , socketIO = require("socket.io")
  , path = require('path');
var fs = require("fs");

var request = require('request'); // "Request" library
var querystring = require('querystring');
var cookieParser = require('cookie-parser');
//initialize our application
var app = express();
var echojs = require('echojs');

var echo = echojs({
  key: "K1RQLGXWBMUAYZOAI"
});

app.use(express.static(path.join(__dirname, 'assets')));
app.use( require('express-subdomain-handler')({ baseUrl: 'everybodj.com', prefix: 'subdomain', logger: true }));
var server = http.createServer(app).listen(process.env.PORT || 8000);
console.log(process.env.PORT);
var io = socketIO.listen(server);

io.set("origins=*");

var rooms = ['Main'];
//settings
var settings = {
  'view_directory': '/views'
}


app.get('/android', function(request, response){
  response.sendfile(__dirname + settings.view_directory + '/index.html');
  response.header("Access-Control-Allow-Origin", "*");
  response.header("Access-Control-Allow-Headers", "X-Requested-With");
  response.header("Access-Control-Allow-Headers", "Content-Type");
  response.header("Access-Control-Allow-Methods", "PUT, GET, POST, DELETE, OPTIONS");
  response.sendfile(__dirname + settings.view_directory + '/index.html')
});
app.get('subdomain/m', function(request, response){
  response.sendfile(__dirname + settings.view_directory + '/index.html');
  response.header("Access-Control-Allow-Origin", "*");
  response.header("Access-Control-Allow-Headers", "X-Requested-With");
  response.header("Access-Control-Allow-Headers", "Content-Type");
  response.header("Access-Control-Allow-Methods", "PUT, GET, POST, DELETE, OPTIONS");
  response.sendfile(__dirname + settings.view_directory + '/index.html')
});
app.get('/', function(request, response){
	response.sendfile(__dirname + settings.view_directory + '/song/index.html');
  response.header("Access-Control-Allow-Origin", "*");
  response.header("Access-Control-Allow-Headers", "X-Requested-With");
  response.header("Access-Control-Allow-Headers", "Content-Type");
  response.header("Access-Control-Allow-Methods", "PUT, GET, POST, DELETE, OPTIONS");
});
app.get('/index.html', function(request, response){
  response.sendfile(__dirname + settings.view_directory + '/song/index.html');
  response.header("Access-Control-Allow-Origin", "*");
  response.header("Access-Control-Allow-Headers", "X-Requested-With");
  response.header("Access-Control-Allow-Headers", "Content-Type");
  response.header("Access-Control-Allow-Methods", "PUT, GET, POST, DELETE, OPTIONS");
});

app.get('/ntunes', function(request, response){
  response.sendfile(__dirname + settings.view_directory + '/ntunes/index.html');
});
app.get('/infinite', function(request, response){
  response.sendfile(__dirname + settings.view_directory + '/infinite/index.html');
});
app.get('/search', function(request, response){
  echo('song/search').get({
    title: request.query.q
  }, function (err, json) {
    console.log(json.response);
    response.json(json.response.songs);
    response.end();
  });
});

app.post('/file-upload', function(req, res) {
    fs.readFile(req.files.thumbnail.path, function (err, data) {
      // ...
      var newPath = './assets/images/' + req.files.thumbnail.name;
      fs.writeFile(newPath, data, function (err) {
        console.log(err);
        res.redirect("back");
      });
    });
});

//chat using socket.io
io.sockets.on('connection', function(client){
	// Room stuff
	client.on("create_room", function(room) {
		rooms.push(room);
		console.log(rooms)
		var oldroom;
		client.room = room;
		oldroom = client.room;
		console.log(oldroom);
		client.leave(client.room);
		client.join(room);
		client.emit("room_name", room);
	});
	var songs = fs.readdirSync("./assets/songs/");
	console.log(songs);
  //when client sends a join event
  client.on('join', function(data){
		io.emit('message', { message: songs + " just joined!", nickname: "Server Announcement" });
		client.room = "Main";
		client.join('Main');
  });
	client.emit('message', songs);
	client.on("change_bg", function(data){
		console.log(data);
    client.broadcast.emit("change_bg", data);
	});
	client.on("change_stroke", function(data){
		console.log(data);
		client.broadcast.emit("stroke", data);
 	});
	client.on("change_wave", function(data){
		client.broadcast.emit("change_wave", data);
 	});
   client.on("draw", function(data) {
     console.log(data.x);
   })
});
