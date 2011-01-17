# To change this template, choose Tools | Templates
# and open the template in the editor.
#this is junk
class MusicFactory
  MAIN_DIR = "public/music"

  def self.init_library
    puts "STARTING GENERATION"
    start_time = Time.now
    Artist.connection.execute("TRUNCATE TABLE artists")
    Album.connection.execute("TRUNCATE TABLE albums")
    Song.connection.execute("TRUNCATE TABLE songs")
    
    Dir["#{MAIN_DIR}/*"].each do |artist_path|
      artist_name = artist_path["#{MAIN_DIR}/".length..-1]
      a = Artist.new(:name => artist_name)
      Dir["#{artist_path}/*"].each do |album_path|
        album_name = album_path["#{artist_path}/".length..-1]
        album = Album.new(:name => album_name)
        album.songs = Dir["#{album_path}/*"].map do |sp|
          name = sp["#{album_path}/".length..-1]
          path = sp["public".length..-1]
          Song.new( :name => name, :full_path => path )
        end
        a.albums << album
      end
      a.save
    end
    puts "COMPLETED IN #{Time.now - start_time}"
  end

  #deprecated
  def self.all_music
    if defined?(@@all_music)
      if Time.now - @@all_music_time > 10.minutes
        RAILS_DEFAULT_LOGGER.info "regenerating library: #{Time.now - @@all_music_time}"
        generate_library
      end
    else
      generate_library
    end
    @@all_music
  end

  #deprecated
  def self.all_songs
    generate_library unless defined?(@@all_songs)
    @@all_songs
  end

  #deprecated
  def self.generate_library
    start_time = Time.now
    all_music = {}
    Dir["#{MAIN_DIR}/*"].each do |artist_path|
      artist = artist_path["#{MAIN_DIR}/".length..-1]
      all_music[artist] = {}
      Dir["#{artist_path}/*"].each do |album_path|
        album = album_path["#{artist_path}/".length..-1]
        all_music[artist][album] = Dir["#{album_path}/*"].map{|sp| sp["#{album_path}/".length..-1] }
      end
    end
    @@all_music = all_music
    @@all_music_time = Time.now
    @@all_songs = Dir["#{MAIN_DIR}/*/*/*"].flatten.uniq.map{|sp| sp["public".length..-1] }
    RAILS_DEFAULT_LOGGER.info "it takes #{Time.now - start_time} seconds (#{@@all_songs.size} songs)."
    puts "it takes #{Time.now - start_time} seconds (#{@@all_songs.size} songs)."
  end
  
  def self.create_logger(filename)
    log_file = File.open("#{RAILS_ROOT}/log/#{filename}", 'a+')
    log_file.sync = true
    Logger.new(log_file)
  end

  

end
