##Socket.io with objective-c example.

###For running the app


Change IP address at sockio-server/views/index.html 

```
var socket = io.connect("192.168.1.10:3000");
```
Change IP address at sockio-server/assets/js/player.js

It's toward the bottom of the document.

Run the web server like this

	node ./sockio-server/app.js

Access the color suite page from browser with:
	
	localhost:3000 
	
Access the music visualizer page from browser with:
	
	localhost:3000/main
	
	

Change IP address in Objective-C views, at top of document

```
[_socketIO connectToHost:@"localhost" onPort:3000];
```
	
