##Socket.io with objective-c example.

###For running the app


Change IP address at sockio-server/views/index.html 

```
var socket = io.connect("192.168.1.10:3000");
```
Change IP address at sockio-server/assets/js/player.js

It's toward the bottom of the document.

Run socket.io chat like

	node ./sockio-server/app.js
	

Change IP address in Objective-C views, at top of document

```
[_socketIO connectToHost:@"localhost" onPort:3000];
```
	
