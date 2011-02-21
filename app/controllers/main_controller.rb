class MainController < ApplicationController

  #TODO: shud go in config file
  MAX_RESULTS = 20

  def index
    #@all_artists = Artist.all.map(&:name)
    @song = Song.find_by_id(params[:song_id], :include => {:album => :artist})
  end
  alias_method :direct, :index

  def get_artists
    artists = if params[:artist_alphabet]
      if params[:artist_alphabet] == "#"
        Artist.all(:conditions => ["name REGEXP '^[^a-z]+'"])
      else
        Artist.all(:conditions => ["name like ?", "#{params[:artist_alphabet]}%"])
      end
    else
      Artist.all
    end
    if artists.blank?
      render :text => "no artists found."
    else
      render :partial => "artists", :locals => {:artists => artists}
    end
  end

  def get_albums
    albums = if params[:artist_id]
      Album.find_all_by_artist_id(params[:artist_id].to_i)
    elsif params[:artist_name]
      Album.all(:joins => :artist, :conditions => ["artists.name=?", params[:artist_name]])
    end
    if albums.blank?
      render :text => "no albums found."
    else
      #extra parameter for panel opening problem
      more_params = params[:ignore_single_album] ? {:ignore_single_album => 1} : {}
      render :partial => "albums", :locals => {:albums => albums}.merge(more_params)
    end
  end

  def autocomplete_artists
    render :text => Artist.all(:conditions => ["name like ?", "%#{params[:q]}%"]).map(&:name).join("\n")
  end

  def get_songs_by_album
    songs = Song.find_all_by_album_id(params[:album_id].to_i, :include => {:album => :artist})
    if songs.blank?
      render :text => "no songs found."
    else
      render :partial => "songs", :locals => {:songs => songs}
    end
  end

  def get_songs_by_artist
    songs = Album.find_all_by_artist_id(params[:artist_id].to_i, :include => :artist).map(&:songs).flatten
    if songs.blank?
      render :text => "no songs found."
    else
      render :partial => "songs", :locals => {:songs => songs}
    end
  end

  def next_random
    song = if params[:song_id]
      Song.find_by_id(params[:song_id].to_i, :include => {:album => :artist})
    elsif params[:album_id]
      Song.first(:joins => {:album => :artist}, :conditions => ["albums.id=?", params[:album_id].to_i], :order => "RAND()" )
    elsif params[:artist_id]
      Song.first(:joins => {:album => :artist}, :conditions => ["artists.id=?", params[:artist_id].to_i], :order => "RAND()" )
    end || Song.find(rand(Song.maximum(:id)+1), :include => {:album => :artist})
    RAILS_DEFAULT_LOGGER.info "Playing: #{song.full_path}"
    render :json => song.web_info
  end

  def search
    keywords = (params["q"]||"").strip.split
    page = (params["p"]||"0").to_i

    render :text => "" and return if keywords.blank?
    conds_query = (Array.new(keywords.size) {"full_path LIKE ?"}).join(" AND ")
    keywords.map!{|k| "%#{k}%" }
    
    results = Song.all(:conditions => [conds_query]+keywords, :include => {:album => :artist},
      :limit => MAX_RESULTS, :offset => page*MAX_RESULTS)
    render :partial => "search_results", :collection => results, :locals => {:page => page}
  end

  
  protected
  def log_delete_request
    
  end

end
