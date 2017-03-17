class Venue < Dry::Struct
  attribute :name,        T::String
  attribute :songkick_id, T::String
end
