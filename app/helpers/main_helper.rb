module MainHelper
  #artist - song
  def song_info_from_path(path)
    tokens = path.split("/")
    "#{tokens[2]} - #{tokens[4]}"
  end
end
