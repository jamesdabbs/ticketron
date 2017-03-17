module Spotify
  class Scanner
    NameMismatch = Class.new StandardError

    def initialize client:, repository: nil, logger: nil
      @client     = client
      @repository = repository || Repository.new
      @logger     = logger || Rails.logger
    end

    def call
      Artist.find_each { |a| lookup_artist artist: a }
    end

    def lookup_artist artist
      results = client.search 'artist', artist.name
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

    attr_reader :client, :repository, :logger

    def distance a,b
      Levenshtein.distance a,b
    end
  end
end
