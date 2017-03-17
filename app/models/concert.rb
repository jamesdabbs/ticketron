class Concert < Dry::Struct
  attribute :artists,     T::Array.member(Artist)
  attribute :venue,       Venue
  attribute :songkick_id, T::String
  attribute :tickets,     Tickets.optional
  attribute :at,          T::Date

  def self.from_attendee attend
    tickets = if attend.status
      ::Tickets.new status: attend.status, number: attend.number
    end
    from_db attend.concert, tickets: tickets
  end

  def self.from_db concert, tickets: nil
    artists = concert.artists
    venue   = concert.venue

    ::Concert.new \
      artists: artists.map { |a|
      ::Artist.new \
        id: a.id,
        name: a.name,
        spotify_id: a.spotify_id,
        songkick_id: a.songkick_id
      },
      venue:       ::Venue.new(name: venue.name, songkick_id: venue.songkick_id),
      at:          concert.at,
      songkick_id: concert.songkick_id,
      tickets:     tickets
  end
end
