desc 'Initiate Library DB'
task :init_library => :environment do
  MusicFactory.init_library
end
