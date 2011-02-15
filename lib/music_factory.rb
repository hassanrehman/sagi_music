# To change this template, choose Tools | Templates
# and open the template in the editor.
#this is junk
class MusicFactory
  require 'ar-extensions'
  MAIN_DIR = "public/music"
  EXCLUDE_DIRS = /^(\.|\.\.|\.ds.store)$/i


  def self.get_dirs(path)
    Dir.new(path).entries.select do |name|
      not EXCLUDE_DIRS =~ name and File.directory?("#{path}/#{name}")
    end
  end

  def self.init_library_old
    puts "STARTING GENERATION"
    start_time = Time.now
    Artist.connection.execute("TRUNCATE TABLE artists")
    Album.connection.execute("TRUNCATE TABLE albums")
    Song.connection.execute("TRUNCATE TABLE songs")

    song_path_pre = MAIN_DIR.gsub("public", "")
    c = 0
    status_dots = 50
    all_artists = get_dirs(MAIN_DIR)
    division = (all_artists.size.to_f / status_dots.to_f).round.to_i
    puts "*"*status_dots
    all_artists.each_with_index do |artist_name, i|
      a = Artist.new(:name => artist_name)
      get_dirs("#{MAIN_DIR}/#{artist_name}").each do |album_name|
        album = Album.new(:name => album_name)
        album.songs = Dir.new("#{MAIN_DIR}/#{artist_name}/#{album_name}").entries.select do |song_name|
          File.file?("#{MAIN_DIR}/#{artist_name}/#{album_name}/#{song_name}")
        end.collect do |song_name|
          full_path = "#{song_path_pre}/#{artist_name}/#{album_name}/#{song_name}"
          Song.new( :name => song_name, :full_path => full_path, :full_path_hash => full_path.hash )
        end
        c += album.songs.size
        a.albums << album
      end
      a.save!
      print "*" if i%division == 0
    end
    puts "\nGENERATED #{c} SONGS IN #{Time.now - start_time}"
  end

  def self.init_library
    puts "STARTING GENERATION"
    start_time = Time.now

    song_path_pre = MAIN_DIR.gsub("public", "")
    c = 0
    artist_head = %w(id name created_at updated_at)
    artist_rows = []
    artist_index = 1

    album_head = %w(id name artist_id created_at updated_at)
    album_rows = []
    album_index = 1

    song_head = %w(id name album_id full_path created_at updated_at full_path_hash)
    song_rows = []
    song_index = 1

    puts "collecting data"
    time_now = Time.now
    get_dirs(MAIN_DIR).each do |artist_name|
      artist_rows << [artist_index, artist_name, time_now, time_now]
      get_dirs("#{MAIN_DIR}/#{artist_name}").each do |album_name|
        album_rows << [album_index, album_name, artist_index, time_now, time_now]
        Dir.new("#{MAIN_DIR}/#{artist_name}/#{album_name}").entries.select do |song_name|
          File.file?("#{MAIN_DIR}/#{artist_name}/#{album_name}/#{song_name}")
        end.collect do |song_name|
          full_path = "#{song_path_pre}/#{artist_name}/#{album_name}/#{song_name}"
          song_rows << [song_index, song_name, album_index, full_path, time_now, time_now, full_path.hash]
          song_index += 1
        end
        album_index += 1
      end
      artist_index += 1
    end
    puts "collected: #{artist_rows.size} artists, #{album_rows.size} albums, #{song_rows.size} rows"

    Artist.connection.execute("TRUNCATE TABLE artists")
    Album.connection.execute("TRUNCATE TABLE albums")
    Song.connection.execute("TRUNCATE TABLE songs")

    puts "importing artists, albums and songs..."
    Artist.import(artist_head, artist_rows, :validate => false)
    Album.import(album_head, album_rows, :validate => false)
    Song.import(song_head, song_rows, :validate => false)

    puts "done in #{Time.now - start_time} seconds"
  end

  def self.create_logger(filename)
    log_file = File.open("#{RAILS_ROOT}/log/#{filename}", 'a+')
    log_file.sync = true
    Logger.new(log_file)
  end

  

end
