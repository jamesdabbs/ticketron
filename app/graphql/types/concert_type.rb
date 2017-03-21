Types::ConcertType = GraphQL::ObjectType.define do
  name "Concert"

  field :artists,     types[Types::ArtistType]
  field :venue,       Types::VenueType
  field :songkick_id, types.String
  field :at,          types.String
  field :attendees,   types[Types::AttendeeType]
end
