Types::ArtistType = GraphQL::ObjectType.define do
  name "Artist"

  field :name,        types.String
  field :songkick_id, types.String
end
