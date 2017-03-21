Types::MailType = GraphQL::ObjectType.define do
  name "Mail"

  field :id,          types.String
  field :user,        Types::UserType
  field :concert,     Types::ConcertType
  field :from,        types.String
  field :to,          types.String
  field :subject,     types.String
  field :html,        types.String
  field :received_at, types.Float
end
