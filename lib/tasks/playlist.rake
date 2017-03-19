namespace :playlist do
  desc 'Generate playlists for all users'
  task :generate => :environment do
    User.find_each { |u| Spotify::UpdatePlaylistJob.perform_later user }
  end
end
