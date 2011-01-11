# To change this template, choose Tools | Templates
# and open the template in the editor.

class MusicFactory
  MAIN_DIR = "public/music"

  def self.all_music
    if defined?(@@all_music)
      if Time.now - @@all_music_time > 10.minutes
        RAILS_DEFAULT_LOGGER.info "regenerating library: #{Time.now - @@all_music_time}"
        @@all_music = generate_library
        @@all_music_time = Time.now
      end
    else
      @@all_music = generate_library
      @@all_music_time = Time.now
    end
    @@all_music
  end

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
    RAILS_DEFAULT_LOGGER.info "it takes #{Time.now - start_time} seconds."
    return all_music
  end
  
  def self.create_logger(filename)
    log_file = File.open("#{RAILS_ROOT}/log/#{filename}", 'a+')
    log_file.sync = true
    Logger.new(log_file)
  end

  

end
