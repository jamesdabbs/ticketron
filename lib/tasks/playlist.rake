namespace :playlist do
  desc 'Generate playlists for all users'
  task :generate => :environment do
    User.find_each do |u|
      Spotify::PlaylistGenerator.new(user).run
    end
  end
end
