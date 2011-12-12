namespace :import do

  desc "Import local gems into the database"
  task :local, [ :path ] => [ :environment ] do |t, args|
    import = Import.local({ :path => (args[:path] || ARGV[1]) })
    import.process
  end

end
