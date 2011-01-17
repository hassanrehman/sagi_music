class MainController < ApplicationController

  #TODO: shud go in config file
  MAX_RESULTS = 20

  def index
    #@all_artists = Artist.all.map(&:name)
    @song = "/music/#{params[:artist]}/#{params[:album]}/#{params[:song]}" if params["song"]
  end
  
  def direct
    index
  end

  def get_artists
    render :partial => "artists", :locals => {:artists => Artist.all}
  end

  def get_albums
    albums = Album.find_all_by_artist_id(params[:artist_id].to_i)
    if albums.blank?
      render :text => "no albums found."
    else
      render :partial => "albums", :locals => {:artist_id => params[:artist_id].to_i, :albums => albums}
    end
  end

  def get_songs_by_album
    songs = Song.find_all_by_album_id(params[:album_id].to_i)
    if songs.blank?
      render :text => "no songs found."
    else
      render :partial => "songs", :locals => {:songs => songs}
    end
  end

  def get_songs_by_artist
    albums = Album.find_all_by_artist_id(params[:artist_id].to_i)
    if albums.blank?
      render :text => "no songs found."
    else
      songs = albums.map(&:songs).flatten
      if songs.blank?
        render :text => "no songs found."
      else
        render :partial => "songs", :locals => {:songs => songs}
      end
    end
  end

  def next_random
    song = Song.find(rand(Song.maximum(:id)+1))
    RAILS_DEFAULT_LOGGER.info "Playing: #{song.full_path}"
    render :text => song.full_path
  end

  def search
    keyword = params["q"].strip
    page = (params["p"]||"0").to_i

    render :text => "" and return if keyword.blank?

    results = Song.all(:conditions => [ "full_path like ?", "%#{keyword}%" ],
      :limit => MAX_RESULTS, :offset => page*MAX_RESULTS)
    render :partial => "search_results", :collection => results, :locals => {:page => page}
  end

  
  protected
  def log_delete_request
    
  end

end
