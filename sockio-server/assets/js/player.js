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
    wrap = document.querySelector(".wrap"),
    ctx = waveform.getContext( '2d' ),
    dancer, kick;
    ctx.canvas.width  = window.innerWidth;
  var button = document.querySelector('.trigger');
  var openCloseMenu = function() {
      wrap.classList.toggle("open");
      button.classList.toggle('selected');
  };
  button.onclick     = openCloseMenu;
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
    return "hsla(" + (Math.random() * 360) + ", 100%, 50%, 1.0)";
    // return color;
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
      ctx.strokeStyle = '#31ebfb';
    }
  }).on();

	// Initialize waveform styles
  dancer
    .waveform( waveform, { strokeStyle: '#666', strokeWidth: 3 });

	// Next Song recursive function
  function nextSong () {
   dancer.pause();
   dancer.audio.currentTime = dancer.audio.duration;
   i = i + 1;
   dancer.load( document.getElementsByTagName('audio')[i] );
   window.dancer = dancer;
   length = dancer.audio.duration;
   dancer.onceAt(length - 0.1, function() {nextSong();});
   dancer.play();
  }
	// Set default pause state
  var pause = true;

	// Obtain all anchor tags
  var
      nAnchor = document.createElement('A'),
      pAnchor  = document.createElement('A'),
      anchor  = document.createElement('A'),
      supported = Dancer.isSupported(),
      p;
      anchor.setAttribute( 'href', '#' );
      // pAnchor.appendChild( document.createTextNode('Pause' ) );
      pAnchor.setAttribute( 'href', '#' );
      // nAnchor.appendChild(document.createTextNode('Next'));
      nAnchor.setAttribute('href', '#');
  function loaded () {

		// Initialize all anchors


		// Check if not supported
    if ( !supported ) {
      p = document.createElement('P');
      p.appendChild( document.createTextNode( 'Your browser does not currently support either Web Audio API or Audio Data API. The audio may play, but the visualizers will not move to the music; check out the latest Chrome or Firefox browsers!' ) );
    }
  }

	// Load the first file
  // dancer.load(AUDIO_FILE);

	// Initialize the length
  // var length = dancer.audio.duration;


	// Set window.dancer to dancer
  window.dancer = dancer;

	// Add event listener Key Down
	window.addEventListener("keyup", onKeyDown, false);

	// Keydown function, for the DJ
	function onKeyDown(event){
		var keyCode = event.keyCode;
    if($('input').is(':focus')) {
      return true;
    }
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
			// case 39: // Right Arrow - Next Song
			// 		dancer.nextSong();
      // 		break;
			case 40: // Down Arrow - default to all black everything
					if (dancer.wave == 3) {dancer.wave = 0;} else {dancer.wave++;}
          ctx.clearRect(0,0,ctx.canvas.width, ctx.canvas.height);
      		break;
			case 18: // Alt/Option - change wavetype
        	if (dancer.wave == 3) {dancer.wave = 0;} else {dancer.wave++;}
          ctx.clearRect(0,0,ctx.canvas.width, ctx.canvas.height);
      		break;
			case 70: // f-key - request fullscreen
					var elem = document.getElementsByTagName("canvas")[0];
					elem.webkitRequestFullScreen();
      		break;
			case 187: // = key - change background color
					document.getElementById("waveform").style.background = getRandomColor();
      		break;
			case 39: // (/) key - randomly change everything
					kick.offKick = function () {
						ctx.strokeStyle = getRandomColor();
          	ctx.fillStyle = getRandomColor();
      		};
  		}
      return true;
	}

	// Function to dynamically change offKick
	function changeoffKick(color) {
  	kick.offKick = function() {
			ctx.strokeStyle = color;
			ctx.fillStyle = color;
		};
		kick.onKick = function() {
			ctx.strokeStyle = "#fff";
		};
	}

	// Function to dynamically change onKick
	function changeOnKick(color) {
  	kick.onKick = function() {
    	ctx.strokeStyle = color;
		};
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
	};


    function extractTitle(url) {
    var lastSlash = url.lastIndexOf('/');
    if (lastSlash >= 0 && lastSlash < url.length - 1) {
        var res =  url.substring(lastSlash + 1, url.length - 4);
        return res;
    } else {
        return url;
    }
}

function getTitle(title, artist, url) {
    if (title === undefined || title.length === 0 || title == '(unknown title)' || title == 'undefined') {
        if (url) {
            title = extractTitle(url);
        } else {
            title = null;
        }
    } else {
        if (artist !== '(unknown artist)') {
            title = title + ' by ' + artist;
        }
    }
    return title;
}

    function listSong(r) {
    var title = getTitle(r.title, r.artist, null);
    var item = null;
    if (title) {
        item = $('<li>').append(title);

        item.attr('class', 'song-link');
        item.click(function() {
                showPlotPage(r.id);
            });
    }
    return item;
}

function listSongAsAnchor(r) {
    var title = getTitle(r.title, r.artist, r.url);
    var item = $('<li>').html('<a href="index.html?trid=' + r.trid + '">' + title + '</a>');
    return item;
}

function listTracks(tracks) {
    $('#song-list').empty();
    for (var i = 0; i < tracks.length; i++) {
        var s = tracks[i];
        var item = listSong(s);
        if (item) {
            $('#song-list').append(listSongAsAnchor(s));
        }
    }
}
    function searchForTrack(q) {
        console.log("search for a track");
        // var q = $("#search-text").val();
        console.log(q);
        $("#song-list").show();
        $(".artists").hide();
        if (q.length > 0) {
            var url = 'http://labs.echonest.com/Uploader/search';
            $.ajax(url, { q:q, results:50, headers: { 'Access-Control-Allow-Origin': '*' }}, function(data) {
                console.log(data);
                for (var i = 0; i < data.length; i++) {
                    console.log("data");
                }
                // fetchAnalysis(data[0].trid)
                listTracks(data);
            });
        }
    }
    function songsByArtist(artist) {
      $("#song-list").show();
      if (artist.length > 0) {
          $("#song-list").before("<p class='artists'>More songs by this artist</p>");
          var url = 'http://labs.echonest.com/Uploader/search';
          $.getJSON(url, { q:artist, results:10}, function(data) {
              console.log(data);
              for (var i = 0; i < data.length; i++) {
                  console.log("data");
              }
              // fetchAnalysis(data[0].trid)
              listTracks(data);
          });
    }
  }
  function updateTime(audio) {
    var minutes1 = Math.floor(audio / 60);
    var seconds1 = audio - minutes1 * 60;
    var minutes2 = Math.floor(dancer.getTime() / 60);
    var seconds2 = dancer.getTime() - minutes2 * 60;
    $("#duration").text(minutes2 + ":" + seconds2 + "/" + minutes1 + ":" + seconds1);
  }
var time = 0;
    function fetchAnalysis(trid) {
      var url = 'http://static.echonest.com/infinite_jukebox_data/' + trid + '.json';
      $.getJSON(url, function(data) { console.log(data);
        $("body").append('<audio src="' + data.response.track.info.url + '">');
        $("#search").before("<h3>Current Song</h3><p>" + getTitle(data.response.track.title, data.response.track.artist) + "</p>");
        $("#search").before("<p id='duration'></p>");
        songsByArtist(data.response.track.artist);
        var audio = document.createElement("audio");
        audio.src = data.response.track.info.url;
        dancer.load(document.getElementsByTagName("audio")[0]);
        time = dancer.audio.duration;
        document.title = getTitle(data.response.track.title, data.response.track.artist);
        dancer.play();
         })
        .error( function() {
            $("#song-list").before("<p class='artists'>We can't seem to find that track, try another search</p>");
        });
        setInterval(updateTime(time), 1000);
    }

    $("#btn").click(searchForTrack($("#song-name").val()));
    $("#song-name").keyup(function(e) {
        if (e.keyCode == 13) {
          searchForTrack($("#song-name").val());
        }
        if (e.keyCode == 70) {
          return false;
        }
    });



  function processParams() {
      var params = {};
      var q = document.URL.split('?')[1];
      if(q !== undefined){
          q = q.split('&');
          for(var i = 0; i < q.length; i++){
              var pv = q[i].split('=');
              var p = pv[0];
              var v = pv[1];
              params[p] = v;
          }
      }

      if ('trid' in params) {
          var trid = params.trid;
          var thresh = 0;
          fetchAnalysis(trid);
      }
      $("#song-list").hide();
  }
  processParams();
  if (time > 0) {
    setInterval(function(){
      var minutes1 = Math.floor(time / 60);
      var seconds1 = Math.floor(time - minutes1 * 60);
      var minutes2 = Math.floor(dancer.getTime() / 60);
      var seconds2 = Math.floor(dancer.getTime() - minutes2 * 60);
      $("#duration").text(minutes2 + ":" + seconds2 + "/" + minutes1 + ":" + seconds1);
}, 1000);
  }
  $("#tweet").after(function(){
    $(this).after('<a href="https://twitter.com/intent/tweet?button_hashtag=Everybodj' +
                  '&text=Check%20this%20out%20' + document.title + '" class="twitter-share-button" data-lang="en">Tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'
    );
  });
})();
