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

function loadSubPanel(div, url, highlight_link) {
    $(div).show('fast');
    $.ajax({
        url: url,
        beforeSend: function( ) {
            $(div+' .bodytext').html("<br /><br /><img src='/images/loadinfo.gif'><a> Loading ... </a>");
        },
        success: function(data) {
            $(div+' .bodytext').html("<br />"+data);
            if( highlight_link ) {
              $(highlight_link).css('color', 'orange').css('font-size', '14px');
              parent = $(highlight_link).parent();
              parent.scrollTop($(highlight_link).position().top - parent.position().top)
            }
        },
        error: function( ) {
            $(div+' .bodytext').html("<br /> Whooops .. something went wrong");
        }
    });
}

function previousSong() {
    //ASSUMING max and now previous fields are set
    if( $('#nowPrevious').html().length == 0 || $('#maxPrevious').html().length == 0 ) return;
    //when at start, prompt user
    if( $('#nowPrevious').html() == "1" ) {
        alert('at the start');
        return;
    }
    newNowPrevious = parseInt( $('#nowPrevious').html() ) - 1;
    $('#previousPanel #'+newNowPrevious).click();
    $('#nowPrevious').html(newNowPrevious+"");
}

function nextSong() {
    if( $('#nowPrevious').html() == $('#maxPrevious').html() )
        nextRandomSong();
    else {
        newNowPrevious = parseInt( $('#nowPrevious').html() ) + 1;
        $('#previousPanel #'+newNowPrevious).click();
        $('#nowPrevious').html(newNowPrevious+"");
    }
}

function nextRandomSong() {
    params = {};
    if( $('#stickySong').attr('checked') )
        params = {song_id: $('#nowSongId').text()};
    else if( $('#stickyAlbum').attr('checked') )
        params = {album_id: $('#nowAlbumId').text()};
    else if( $('#stickyArtist').attr('checked') )
        params = {artist_id: $('#nowArtistId').text()};
    
    $.getJSON( '/next_random', params, function(data) {
        playSong(data, true);
    });
}

function slug(str) {
    return str.replace(/[^a-z0-9\.]/ig, "-");
}

// parameter expected: hash object (json). see Song#web_info in Song model
// doRecordPrevious has default value true. If false, the song is not recorded
//   for previousSong playback
function playSong(song, doRecordPrevious) {
    niftyplayer('nplayer').load(song["full_path"]);
    niftyplayer('nplayer').play();
    //set current song variables
    $('#nowArtist').html(song["artist_name"]);$('#nowArtistId').text(song["artist_id"]);
    $('#nowAlbum').html(song["album_name"]);$('#nowAlbumId').text(song["album_id"]);
    $('#nowSong').html(song["song_name"]);$('#nowSongId').text(song["song_id"]);
    //direcet link
    path = "/direct/"+song["song_id"]+"/"+slug(song["artist_name"]+" - "+slug(song["song_name"]));
    $('#nowDirectLink').html("<a href=\""+path+"\"> "+"http://"+document.location.host+path+" </a>");
    //title of the page
    $('title').html(song["artist_name"]+" - "+song["song_name"]);

    if( doRecordPrevious === undefined ) {
        doRecordPrevious = true;
    }
    if( doRecordPrevious )
        recordPrevious(song);

    $('#artwork').attr('src', song["artwork_path"]);
}

function recordPrevious(song) {
    next_id = parseInt( $('#nowPrevious').html()||"0" ) + 1;
    max_id = parseInt( $('#maxPrevious').html()||"0" ) + 1;

    //prepare an anchor link with playSong( song_json ), to be called when a previous song is played
    //note that recordPrevious is false is in this case.

    //check to see if the next already exists
    if( $('#previousPanel #'+next_id).size() > 0 ) {
        //if the next div already exists, move all the numbers forward to make its space
        for( i = next_id ; i <= max_id ; i++ )
            $('#previousPanel #'+i).attr('id', (i+1)+"");
    }

    //then add the new div to its respected number
    $('#previousPanel').html($('#previousPanel').html()+"<br /><a href=\"javascript:;\" class=\"previous_song\" id=\""+next_id+"\" onclick=\"playSong({&quot;song_name&quot;:&quot;"+song["song_name"]+"&quot;,&quot;full_path&quot;:&quot;"+song["full_path"]+"&quot;,&quot;full_path_hash&quot;:&quot;"+song["full_path_hash"]+"&quot;,&quot;artwork_path&quot;:&quot;"+song["artwork_path"]+"&quot;,&quot;album_name&quot;:&quot;"+song["album_name"]+"&quot;,&quot;full_path_hash&quot;:"+song["full_path_hash"]+",&quot;song_id&quot;:"+song["song_id"]+",&quot;artist_name&quot;:&quot;"+song["artist_name"]+"&quot;,&quot;artist_id&quot;:"+song["artist_id"]+",&quot;album_id&quot;:"+song["album_id"]+"}, false);\">"+next_id + " - " + song["song_name"]+"</a>");
    
    $('#maxPrevious').html(max_id+"");
    $('#nowPrevious').html(next_id+"");
}

function locateSong() {
    artist = $('#nowArtistId').text();
    album = $('#nowAlbumId').text();
    song = $('#nowSongId').text();    
    loadSubPanel('#artistsMenu', "/get_artists", '#artist_panel_'+$('#nowArtistId').text());
    loadSubPanel('#albumsMenu', "/get_albums?artist_id="+artist+"&ignore_single_album=1", '#album_panel_'+$('#nowAlbumId').text());
    loadSubPanel('#songsMenu', "/get_songs_by_album/"+album, '#song_panel_'+$('#nowSongId').text());
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
