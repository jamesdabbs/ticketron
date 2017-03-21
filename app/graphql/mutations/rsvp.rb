Mutations::RSVP = GraphQL::Relay::Mutation.define do
  name 'RSVP'

  input_field :songkick_id, !types.String
  input_field :tickets,     !types.Int
  input_field :method,      !Types::TicketEnum

  return_field :ok,    types.Boolean
  return_field :error, types.String

  resolve ->(obj, args, ctx) {
    repo = ctx[:container].repository

    repo.add_tickets \
      user:    ctx[:user],
      concert: Hashie::Mash.new(songkick_id: args[:songkick_id]),
      tickets: args[:tickets],
      method:  args[:method]

    { ok: true }
  }
end
