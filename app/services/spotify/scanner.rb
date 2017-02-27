module Spotify
  class Scanner
    NameMismatch = Class.new StandardError

    def initialize user, logger: nil
      @user   = user
      @logger = logger || Rails.logger
    end

    def lookup_artists artists
      artists = Artist.all
      artists.each do |artist|
        results = user.spotify.search 'artist', artist.name
        next unless results['artists'].present?

        items = results['artists']['items']

        found, dist = items.
          map    { |i| [i, distance(i['name'].downcase, artist.name.downcase)] }.
          min_by { |i,d| d }

        if dist > 3
          logger.warn "Name mismatch: #{found['name']} / #{artist.name}"
          next
        end

        artist.update! spotify_id: found['id']
      end
    end

    private

    attr_reader :user, :logger

    def distance a,b
      Levenshtein.distance a,b
    end
  end
end
