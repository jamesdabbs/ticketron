class ConcertResolver
  def call concerts:, query:
    map = concerts.each_with_object({}) do |c, h|
      c.artists.each do |a|
        h[a.name] ||= []
        h[a.name].push c
      end
    end

    match = FuzzyMatch.new(map.keys).find query
    map.fetch match
  end
end
