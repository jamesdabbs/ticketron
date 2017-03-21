Types::VenueType = GraphQL::ObjectType.define do
  name "Venue"

  field :name, types.String
end
