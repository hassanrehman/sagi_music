class MainController < ApplicationController

  def index
    @all_artists = MusicFactory.all_music.keys.sort
  end

  def get_artists
    render :partial => "artists", :locals => {:artists =>MusicFactory.all_music.keys.sort}
  end

  def get_albums
    render :partial => "albums", :locals => {:artist => params[:artist], :albums =>MusicFactory.all_music[params[:artist]].keys.sort}
  end

  def get_songs
    albums = if /^all$/i =~ params[:album]
      MusicFactory.all_music[params[:artist]]
    else
      MusicFactory.all_music[params[:artist]].delete_if{|k,v| k != params[:album] }
    end
    render :partial => "songs", :locals => {:artist => params[:artist], :albums => albums}
  end

  def next_random
    artist = MusicFactory.all_music.keys[rand(MusicFactory.all_music.keys.size)]
    album = MusicFactory.all_music[artist].keys[rand(MusicFactory.all_music[artist].keys.size)]
    song = MusicFactory.all_music[artist][album][rand(MusicFactory.all_music[artist][album].size)]
    song_info = "#{artist} - #{song} (#{album})"
    RAILS_DEFAULT_LOGGER.info "Playing: #{song_info}"
    DeleteRequest.create(:artist => artist, :album => album, :song => song) if params[:request_delete].to_i == 1
    render :text => "music/#{artist}/#{album}/#{song}"
  end

  def search
    render :text => "params: #{params.inspect}"
  end


  protected
  def log_delete_request
    
  end

end
