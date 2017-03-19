class Spotify::UpdatePlaylistJob < ApplicationJob
  queue_as :sync

  def perform user
    container.spotify_playlist_generator.call user
  end
end
