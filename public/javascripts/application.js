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
            tokens = data.split("/")
            playSong(data);
        },
        error: function( ) {
            //$(div+' .bodytext').html("<br /><br /> Whooops .. something went wrong");
            console.log('shit');
        }
    });
}

//path is asumed to be  music/artist/album/song
function playSong(path) {
    niftyplayer('nplayer').load(path);
    niftyplayer('nplayer').play();
    tokens = path.split("/");
    console.log(path);
    $('#nowArtist').html(tokens[1]);
    $('#nowAlbum').html(tokens[2]);
    $('#nowSong').html(tokens[3]);
}

function locateSong( ) {
    artist = $('#nowArtist').html();
    album = $('#nowAlbum').html();
    loadSubPanel('#albumsMenu', "/get_albums/"+artist);
    loadSubPanel('#songsMenu', "/get_songs/"+artist+"/"+album);
}