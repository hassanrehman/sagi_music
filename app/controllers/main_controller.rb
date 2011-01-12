class MainController < ApplicationController

  def index
    @all_artists = MusicFactory.all_music.keys.sort
    if params["song"]
      @song = "/music/#{params[:artist]}/#{params[:album]}/#{params[:song]}"
    end
    RAILS_DEFAULT_LOGGER.info "params: #{params.inspect}"
    RAILS_DEFAULT_LOGGER.info "params: #{@song.inspect}"
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
    song = MusicFactory.all_songs.rand
    RAILS_DEFAULT_LOGGER.info "Playing: #{song}"
    render :text => song
  end

  def search
#    respond_to do |format|
#      format.js {
#        render :update do |page|
#          page.replace_html "search_results", "sjdh"
#        end
#      }
#    end
    render :text => "params: #{params.inspect}"
  end

  def direct
    index
  end

  protected
  def log_delete_request
    
  end

end
