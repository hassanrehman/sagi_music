desc 'Initiate Library DB'
task :init_library => :environment do
  MusicFactory.init_library
end

desc 'Initiate Library DB the old way'
task :init_library_old => :environment do
  MusicFactory.init_library_old
end
