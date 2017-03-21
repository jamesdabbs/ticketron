module Spotify
  class PlaylistFinder < Gestalt[:repository, :client_builder]
    def call user, playlist_name: 'Ticketron'
      spotify = client_builder.call user

      if playlist = repository.spotify_playlist(user: user)
        return playlist
      end

      user_id   = spotify.me.fetch('id') # FIXME: shouldn't need this query
      playlists = spotify.user_playlists(user_id).fetch('items', [])
      found     = playlists.find { |p| p.fetch('name') == playlist_name }
      unless found
        found = spotify.create_user_playlist(user_id, playlist_name)
      end

      repository.update_spotify_playlist \
        user:    user,
        user_id: user_id,
        id:      found.fetch('id'),
        url:     found.fetch('external_urls').fetch('spotify')

      repository.spotify_playlist user: user
    end
  end
end
