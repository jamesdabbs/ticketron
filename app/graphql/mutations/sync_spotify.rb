Mutations::SyncSpotify = GraphQL::Relay::Mutation.define do
  name "SyncSpotify"
  # TODO: define return fields
  # return_field :post, Types::PostType

  # TODO: define arguments
  # input_field :name, !types.String

  resolve ->(obj, args, ctx) {
    # TODO: define resolve function
  }
end
