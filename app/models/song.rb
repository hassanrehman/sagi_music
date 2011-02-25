require 'mp3info'
class Song < ActiveRecord::Base
  belongs_to :album

  def web_info
    #TODO: find a better way to CGI::escape the path
    {:full_path => full_path.split("/").collect{|t| CGI::escape(t)}.join("/"),
     :full_path_hash => full_path_hash,
     :artwork_path => artwork_path,

     :song_id => id,
     :album_id => album.id,
     :artist_id => album.artist.id,

     :song_name => name,
     :album_name => album.name,
     :artist_name => album.artist.name}
  end

  def artwork_path
    artwork_hash = "#{album.artist.name}#{album.name}".hash
    artwork_path = if File.exists?("public/artwork/#{artwork_hash}")
      "/artwork/#{artwork_hash}"
    else
      begin
        mp3 = Mp3Info.open("public#{full_path}")
        if mp3.tag2
          if mp3.tag2["APIC"]
            text_encoding, mime_type, picture_type, description, picture_data = mp3.tag2["APIC"].unpack("c Z* c Z* a*")
            File.open("public/artwork/#{artwork_hash}", 'w') { |f| f.puts picture_data }
            return "/artwork/#{artwork_hash}"
          end
        end
      rescue
      end
      nil
    end
    artwork_path || "/images/noartwork.gif"
  end

end
