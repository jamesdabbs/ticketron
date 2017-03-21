Types::AttendeeType = GraphQL::ObjectType.define do
  name "Attendee"

  field :user, Types::UserType

  field :number, types.Int

  field :status, types.String do
    resolve ->(obj, args, ctx) {
      obj.status.label
    }
  end
end
