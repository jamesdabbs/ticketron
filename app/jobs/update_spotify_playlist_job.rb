class UpdateSpotifyPlaylistJob < ApplicationJob
  def perform user
    container.spotify_playlist_generator.call user
  end
end
