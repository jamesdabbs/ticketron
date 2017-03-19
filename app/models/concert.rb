class Concert < Dry::Struct
  attribute :artists,     T::Array.member(Artist)
  attribute :venue,       Venue
  attribute :songkick_id, T::String
  attribute :at,          T::Date
  attribute :attendees,   T::Array.member(Tickets)
end
