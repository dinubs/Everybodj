// Gavin Dinubilo
// player.js - built to cooperate with dancer.js
// dancer.js - https://github.com/jsantell/dancer.js
// This is an experiment, or experience
// 		Whatever you please
// This code is for you to use, and tamper with
// :)

(function () {
  var
    AUDIO_FILE = document.getElementsByTagName('audio')[0],
    i = 0,
    waveform = document.getElementById( 'waveform' ),
    ctx = waveform.getContext( '2d' ),
    dancer, kick;
    ctx.canvas.width  = window.innerWidth;

  var colors = ['#123456',
                '#bada55',
                '#00FFFF',
                '#FFFF00',
                '#00FF00',
                '#FF007C',
                '#fff',
                '#000',
                '#C534FF',
                '#FF3C32',
                '#29FF3C'
                ];
  Dancer.setOptions({
    flashSWF : 'lib/soundmanager2.swf',
    flashJS  : 'lib/soundmanager2.js'
  });

  function getRandomColor() {
    var letters = '0123456789ABCDEF'.split('');
    var color = '#';
    // color = colors[Math.floor(Math.random() * colors.length)];
		for(var i = 0; i < 6; i++) {
			color += letters[Math.floor(Math.random() * letters.length)];
		}
    return color;
  }

  dancer = new Dancer();
  kick = dancer.createKick({
    onKick: function() {
      // ctx.strokeStyle= getRandomColor();
      ctx.strokeStyle = '#fff';
    },
    offKick: function() {
      dancer.waveform.spacing = dancer.getFrequency(400, 800);
      // ctx.strokeStyle= getRandomColor();
      ctx.strokeStyle = '#123456';
    }
  }).on();

	// Initialize waveform styles
  dancer
    .waveform( waveform, { strokeStyle: '#666', strokeWidth: 3 });

	// Check if dancer is supported
  Dancer.isSupported() || loaded();
  !dancer.isLoaded() ? dancer.bind( 'loaded', loaded ) : loaded();

	// Next Song recursive function
  function nextSong () {
   dancer.pause();
   dancer.audio.currentTime = dancer.audio.duration;
   i = i + 1;
   console.log(i);
   dancer.load( document.getElementsByTagName('audio')[i] );
   window.dancer = dancer;
   length = dancer.audio.duration;
   console.log(length);
   dancer.onceAt(length - 0.1, function() {nextSong();});
   dancer.play();
  }
	// Set default pause state
  var pause = true;

	// Obtain all anchor tags
  var
      loading = document.getElementById( 'loading' ),
      pause = document.getElementById( 'pause' ),
      next = document.getElementById('next'),
      nAnchor = document.createElement('A'),
      pAnchor  = document.createElement('A'),
      anchor  = document.createElement('A'),
      supported = Dancer.isSupported(),
      p;
  function loaded () {

		// Initialize all anchors
    anchor.appendChild( document.createTextNode( supported ? 'Play Jams!' : 'Close' ) );
    anchor.setAttribute( 'href', '#' );
    pAnchor.appendChild( document.createTextNode('Pause' ) );
    pAnchor.setAttribute( 'href', '#' );
    nAnchor.appendChild(document.createTextNode('Next'));
    nAnchor.setAttribute('href', '#');
    pause.innerHTML = '';
    pause.appendChild( pAnchor );
    loading.innerHTML = '';
    loading.appendChild( anchor );
    next.innerHTML = '';
    next.appendChild(nAnchor);

		// Check if not supported
    if ( !supported ) {
      p = document.createElement('P');
      p.appendChild( document.createTextNode( 'Your browser does not currently support either Web Audio API or Audio Data API. The audio may play, but the visualizers will not move to the music; check out the latest Chrome or Firefox browsers!' ) );
      loading.appendChild( p );
    }

		// Add pause button event-listener
    pAnchor.addEventListener( 'click', function () {
      if (pause) {dancer.pause();pause = false; pAnchor.innerText = 'Play';}else {dancer.play(); pause = true;pAnchor.innerText = 'Pause';};

    });

		// Add "Play Jams!!" event-listener
    anchor.addEventListener( 'click', function () {
      dancer.play();
      document.getElementById('loading').style.display = 'none';
      document.getElementById('pause').style.display = 'inline-block';
      document.getElementById('next').style.display = 'inline-block';
    });

		// Add "Next Song" event-listener
    nAnchor.addEventListener('click', function() {
      nextSong();
    });
  }

	// Load the first file
  // dancer.load(AUDIO_FILE);

	// Initialize the length
  // var length = dancer.audio.duration;


	// Set window.dancer to dancer
  window.dancer = dancer;

	// Add event listener Key Down
	window.addEventListener("keydown", onKeyDown, false);

	// Keydown function, for the DJ
	function onKeyDown(event){
		var keyCode = event.keyCode;

		switch(keyCode){
			case 32: // Space Bar - Play/Pause
					if (pause) {
						dancer.pause();
						pause = false;
						pAnchor.innerText = 'Play';
					} else {
						dancer.play();
						pause = true;
          	pAnchor.innerText = 'Pause';
					}
      		break;
			case 37:  // Left Arrow - Random Color/Off Kick
					changeoffKick(getRandomColor());
      		break;
			case 38: // Up Arrow - default to cool colors
					changeoffKick("#ff007c");
					changeOnKick("#000");
      		break;
			case 39: // Right Arrow - Next Song
					nextSong();
      		break;
			case 40: // Down Arrow - default to all black everything
					changeoffKick('#000');
					changeOnKick('#000');
					document.getElementById("waveform").style.background = '#000';
      		break;
			case 18: // Alt/Option - change wavetype
        	if (dancer.wave == 2) {dancer.wave = 0} else {dancer.wave++;};
      		break;
			case 70: // f-key - request fullscreen
					var elem = document.getElementsByTagName("canvas")[0];
					elem.webkitRequestFullScreen();
      		break;
			case 187: // = key - change background color
					document.getElementById("waveform").style.background = getRandomColor();
      		break;
			case 191: // (/) key - randomly change everything
					kick.offKick = function () {
						ctx.strokeStyle = getRandomColor();
          	ctx.fillStyle = getRandomColor();
      		}
  		}
	}

	// Function to dynamically change offKick
	function changeoffKick(color) {
  	kick.offKick = function() {
			ctx.strokeStyle = color;
			ctx.fillStyle = color;
		}
		kick.onKick = function() {
			ctx.strokeStyle = "#fff";
		}
	}

	// Function to dynamically change onKick
	function changeOnKick(color) {
  	kick.onKick = function() {
    	ctx.strokeStyle = color;
		}
	}

	// Function to lighten colors
	LightenDarkenColor = function(col, amt) {
				var usePound = false;
				// Taking out the # character
	    	if (col[0] == "#") {
	      		col = col.slice(1);
	        	usePound = true;
					}
				// Starting the lightening
				var num = parseInt(col,16);
				var r = (num >> 16) + amt;
				if (r > 255) r = 255;
				else if  (r < 0) r = 0;
				var b = ((num >> 8) & 0x00FF) + amt;
				if (b > 255) b = 255;
				else if  (b < 0) b = 0;
				var g = (num & 0x0000FF) + amt;
				if (g > 255) g = 255;
				else if (g < 0) g = 0;
				// Colors have been enlightened
				// Return lightened color
				return (usePound?"#":"") + (g | (b << 8) | (r << 16)).toString(16);
	}

	// Socket.io functions to communicate with phone
	// Connect to server

	var socket = io.connect("107.20.137.240:80"); // Change the IP address in this function to yours to connect to your Node.js server
		socket.emit("join", "hello");
		// Change Stroke
		socket.on("stroke", function(col){
			kick.offKick = function() {
		  	ctx.strokeStyle = col;
				dancer.speed = 10;
			}
			kick.onKick = function() {
				ctx.strokeStyle  = "#fff";
				dancer.speed = 5;
			}
			console.log(col);
		});

		// Change Background
		socket.on("change_bg", function(col){
			// document.getElementById("waveform").style.background = col;
      dancer.bgColor = col;
      console.log(dancer.bgColor);

		});
		socket.on("message", function(data){
			console.log(data);
			for (var i = 1; i < data.length; i++) {
				$("body").append('<audio src="/songs/' + data[i] + '">');
				// var audio = document.createElement("audio");
				// audio.src = data[i];
			}
			dancer.load(document.getElementsByTagName("audio")[0]);
			// Begin the recursive nextSong() function
		  dancer.onceAt(length - 1, function() {
		      nextSong();
		  });
		});

		// Change Wavetype
		socket.on("change_wave", function(wave){
			dancer.wave = parseInt(wave);
		});

})();
