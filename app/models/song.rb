class Song < ActiveRecord::Base
  belongs_to :album

  def web_info
    #TODO: find a better way to CGI::escape the path
    {:full_path => full_path.split("/").collect{|t| CGI::escape(t)}.join("/"),
     :full_path_hash => full_path_hash,
     :song_id => id,
     :album_id => album.id,
     :artist_id => album.artist.id,

     :song_name => name,
     :album_name => album.name,
     :artist_name => album.artist.name}
  end

end
