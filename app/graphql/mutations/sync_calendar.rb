Mutations::SyncCalendar = GraphQL::Relay::Mutation.define do
  name 'SyncCalendar'

  return_field :updatedAt, types.Float

  resolve ->(obj, args, ctx) {
    ctx[:container].google_calendar_sync user: ctx[:user]

    { updatedAt: Time.now }
  }
end
