function loadSearchResults(keyword_id, update_id) {
  keyword = $(keyword_id).val();
  $.ajax({
        url: '/main/search?q='+keyword,
        beforeSend: function() {
            //$(div+' .bodytext').html("<br /><br /><img src='/images/loadinfo.gif'><a> Loading ... </a>");
        },
        success: function(data) {
          //$(update_id).replace(data);
          $(update_id).html(data);
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
    if( $('#stickySong').attr('checked') ) {
        playSong($('#nowDirectLink a').attr('href').replace('direct', 'music'));
    }
    else {
        //TODO: send params as artist and/or album ids to select next random
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
    $('title').html(tokens[2]+" - "+tokens[4]);
}

function locateSong() {
    artist = $('#nowArtist').html();
    album = $('#nowAlbum').html();
    loadSubPanel('#albumsMenu', "/get_albums/"+artist);
    loadSubPanel('#songsMenu', "/get_songs/"+artist+"/"+album);
}

function toggleSticky(field) {
    if( $(field).attr('id') == 'stickyArtist'  ) {
        if( !$(field).attr('checked') ) {
            $('#stickyAlbum').attr('checked', false);
            $('#stickySong').attr('checked', false);
        }
    }
    else if( $(field).attr('id') == 'stickyAlbum'  ) {
        if( $(field).attr('checked') ) {
            $('#stickyArtist').attr('checked', true);
        }
        else {
            $('#stickySong').attr('checked', false);
        }
    }
    else if( $(field).attr('id') == 'stickySong'  ) {
        if( $(field).attr('checked') ) {
            $('#stickyArtist').attr('checked', true);
            $('#stickyAlbum').attr('checked', true);
        }
    }
}