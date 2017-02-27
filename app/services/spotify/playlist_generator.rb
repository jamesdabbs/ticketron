module Spotify
  class PlaylistGenerator
    AddingFailed = Class.new StandardError

    def initialize user
      @user = user
    end

    def run
      playlist = get_playlist 'Ticketron'

      tracks = []
      user.upcoming_artists.each do |artist|
        # TODO: weight by how long until the concert
        tracks += spotify.artist_top_tracks(artist.spotify_id, user.country)['tracks']
      end

      # Spotify limits the number of tracks added per request to 100,
      #   but recommends smaller numbers.
      # See https://developer.spotify.com/web-api/add-tracks-to-playlist
      tracks.each_slice 25 do |ts|
        uris = ts.map { |t| t.fetch 'uri' }

        result = spotify.add_user_tracks_to_playlist \
          user.spotify_id, playlist.fetch('id'), uris
        raise AddingFailed unless result
      end

      playlist
    end

    private

    attr_reader :user

    def spotify
      user.spotify
    end

    def get_playlist name
      playlists = spotify.user_playlists(user.spotify_id)
      found     = playlists['items'].find { |p| p.fetch('name') == name }
      return found if found
      spotify.create_user_playlist user.spotify_id, name
    end
  end
end
