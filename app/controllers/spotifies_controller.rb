class SpotifiesController < ApplicationController
  def update
    UpdateSpotifyPlaylistJob.new.perform current_user
    redirect_back success: 'Playlist generated', fallback_location: profile_path
  end

  def show
    playlist = container.spotify_playlist_finder.call(current_user)
    unless playlist.updated_at > 1.day.ago
      UpdateSpotifyPlaylistJob.perform_later current_user
    end
    redirect_to playlist.url
  end
end
