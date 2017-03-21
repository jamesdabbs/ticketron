class Spotify::ScanArtistJob < ApplicationJob
  queue_as :sync

  def perform songkick_id:
    artist = repository.artist_by_songkick_id songkick_id
    return unless artist
    return if artist.spotify_id

    container.spotify_scanner.call artists: [artist], spotify: container.spotify_client
  end
end
