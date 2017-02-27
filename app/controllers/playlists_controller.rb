class PlaylistsController < ApplicationController
  def update
    Spotify::PlaylistGenerator.new(current_user).run
    redirect_to :back, success: 'Playlist generated'
  end

  def show
    playlists = current_user.spotify.user_playlists(current_user.spotify_id)['items']
    found = playlists.find { |p| p.fetch('name') == 'Ticketron' }
    if found
      redirect_to found.fetch('external_urls').fetch('spotify')
    else
      redirect_to :back, error: 'No playlist found'
    end
  end
end
