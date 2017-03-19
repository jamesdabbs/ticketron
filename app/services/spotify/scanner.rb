module Spotify
  class Scanner < Gestalt[:repository]
    def call artists:, spotify:
      artists.each { |a| lookup_artist artist: a, spotify: spotify }
    end

    def lookup_artist artist:, spotify:
      results = spotify.search 'artist', artist.name
      return unless results['artists'].present?

      items = results['artists']['items']

      found, dist = items.
        map    { |i| [i, distance(i['name'].downcase, artist.name.downcase)] }.
        min_by { |i,d| d }

      if dist > 3
        logger.warn "Name mismatch: #{found['name']} / #{artist.name}"
        return
      end

      repository.update_spotify_id artist: artist, spotify_id: found['id']
    end

    private

    def distance a,b
      Levenshtein.distance a,b
    end

    def logger
      Rails.logger
    end
  end
end
