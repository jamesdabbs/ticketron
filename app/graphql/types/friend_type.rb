Types::FriendType = GraphQL::ObjectType.define do
  name 'Friend'

  field :user,     Types::UserType
  field :approved, types.Boolean
end
