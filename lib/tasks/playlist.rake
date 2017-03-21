namespace :playlist do
  desc 'Generate playlists for all users'
  task :sync => :environment do
    DB::Identity.where(provider: Identity::Spotify).find_each do |id|
      Spotify::UpdatePlaylistJob.perform_later user: id.user
    end
  end
end
