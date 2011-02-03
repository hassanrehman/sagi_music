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

function nextRandomSong() {
    params = {};
    if( $('#stickySong').attr('checked') )
        params = {song_id: $('#nowSongId').text()};
    else if( $('#stickyAlbum').attr('checked') )
        params = {album_id: $('#nowAlbumId').text()};
    else if( $('#stickyArtist').attr('checked') )
        params = {artist_id: $('#nowArtistId').text()};
    
    $.getJSON( '/next_random', params, function(data) {
        playSong(data);
    });
}

function slug(str) {
    return str.replace(/[^a-z0-9\.]/ig, "-");
}

// parameter expected: hash object (json). see Song#web_info in Song model
function playSong(song) {
    niftyplayer('nplayer').load(song["full_path"]);
    niftyplayer('nplayer').play();
    console.log(song["full_path"]);
    //set current song variables
    $('#nowArtist').html(song["artist_name"]);$('#nowArtistId').text(song["artist_id"]);
    $('#nowAlbum').html(song["album_name"]);$('#nowAlbumId').text(song["album_id"]);
    $('#nowSong').html(song["song_name"]);$('#nowSongId').text(song["song_id"]);
    //direcet link
    path = "/direct/"+song["song_id"]+"/"+slug(song["artist_name"]+" - "+slug(song["song_name"]));
    $('#nowDirectLink').html("<a href=\""+path+"\"> Direct Link </a>");
    //title of the page
    $('title').html(song["artist_name"]+" - "+song["song_name"]);
}

function locateSong() {
    artist = $('#nowArtistId').text();
    album = $('#nowAlbumId').text();
    song = $('#nowSongId').text();
    parent = $("#artist_panel_"+artist).parent();
    //clear all children's css
    parent.children("a").css('color', '').css('font-size', '');
    //highlight artist
    $("#artist_panel_"+artist).css('color', 'orange').css('font-size', '14px');
    //scroll the pane
    parent.scrollTop(0);
    parent.scrollTop($("#artist_panel_"+artist).position().top - parent.position().top)
    
    loadSubPanel('#albumsMenu', "/get_albums/"+artist+"?ignore_single_album=1", '#album_panel_'+$('#nowAlbumId').text());
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