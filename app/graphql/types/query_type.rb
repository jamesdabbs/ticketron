Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :viewer, Types::ViewerType do
    resolve ->(obj, args, ctx) { ctx[:user] }
  end
end
