Mutations::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :rsvp,          field: Mutations::RSVP.field
  field :syncCalendar,  field: Mutations::SyncCalendar.field
  field :syncSpotify,   field: Mutations::SyncSpotify.field
  field :createConcert, field: Mutations::CreateConcert.field
  field :requestFriend, field: Mutations::RequestFriend.field
  field :approveFriend, field: Mutations::ApproveFriend.field

  # - retry mail?
  # - request tickets?
  # - approve tickets?
end
