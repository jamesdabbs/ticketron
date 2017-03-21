Types::UserType = GraphQL::ObjectType.define do
  name "User"

  field :name, types.String
end
