function loadSearchResults(keyword_id, update_id) {
  keyword = $(keyword_id).value;

  $.ajax({
        url: '/main/search',
        params: { q: keyword },
        beforeSend: function() {
            //$(div+' .bodytext').html("<br /><br /><img src='/images/loadinfo.gif'><a> Loading ... </a>");
        },
        success: function(data) {
          //$(update_id).replace(data);
        document.getElementById(update_id).innerHTML = data;
        },
        error: function( ) {
            //$(div+' .bodytext').html("<br /><br /> Whooops .. something went wrong");
            console.log('shit');
        }
    });
}

function loadSubPanel(div, url) {
    $(div).show('fast');
    $.ajax({
        url: url,
        beforeSend: function( ) {
            $(div+' .bodytext').html("<br /><br /><img src='/images/loadinfo.gif'><a> Loading ... </a>");
        },
        success: function(data) {
            $(div+' .bodytext').html("<br /><br />"+data);
        },
        error: function( ) {
            $(div+' .bodytext').html("<br /><br /> Whooops .. something went wrong");
        }
    });
}

function nextRandomSong(request_delete) {
    $.ajax({
        url: '/next_random',
        params: {request_delete: request_delete},
        beforeSend: function() {
            //$(div+' .bodytext').html("<br /><br /><img src='/images/loadinfo.gif'><a> Loading ... </a>");
        },
        success: function(data) {
            playSong(data);
        },
        error: function( ) {
            //$(div+' .bodytext').html("<br /><br /> Whooops .. something went wrong");
            console.log('shit');
        }
    });
}

//path is asumed to be  /music/artist/album/song
function playSong(path) {
    niftyplayer('nplayer').load(path);
    niftyplayer('nplayer').play();
    tokens = path.split("/");   //ignore the first ..  its always empty
    console.log(path);
    $('#nowArtist').html(tokens[2]);
    $('#nowAlbum').html(tokens[3]);
    $('#nowSong').html(tokens[4]);
    info = tokens[2]+"/"+tokens[3]+"/"+tokens[4];
    $('#nowDirectLink').html("<a href=\"/direct/"+info+"\">"+info+"</a>");
}

function locateSong( ) {
    artist = $('#nowArtist').html();
    album = $('#nowAlbum').html();
    loadSubPanel('#albumsMenu', "/get_albums/"+artist);
    loadSubPanel('#songsMenu', "/get_songs/"+artist+"/"+album);
}
