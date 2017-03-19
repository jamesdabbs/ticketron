module Spotify
  class PlaylistGenerator < Gestalt[:repository, :client_builder, :finder, :scanner]
    def call user
      spotify  = client_builder.call user
      playlist = finder.call user

      scan_artists user: user, spotify: spotify

      tracks = []
      upcoming_artists(user: user).each do |artist|
        next unless artist.spotify_id
        # TODO: weight by how long until the concert
        tracks += spotify.artist_top_tracks(artist.spotify_id, 'us')['tracks']
      end

      # Spotify limits the number of tracks added per request to 100,
      #   but recommends smaller numbers.
      # See https://developer.spotify.com/web-api/add-tracks-to-playlist
      tracks.each_slice 25 do |ts|
        uris = ts.map { |t| t.fetch 'uri' }

        result = spotify.add_user_tracks_to_playlist \
          playlist.user_id, playlist.id, uris
        raise Spotify::AddingFailed unless result
      end

      repository.spotify_playlist_updated user: user

      playlist
    end

    private

    def scan_artists user:, spotify:
      scanner.call spotify: spotify, artists: upcoming_artists(user: user)
    end

    def upcoming_artists user:
      repository.upcoming_concerts(user: user).map(&:artists).flatten.uniq
    end
  end
end
