class Artist < Dry::Struct
  attribute :id,          T::Int
  attribute :name,        T::String
  attribute :spotify_id,  T::String
  attribute :songkick_id, T::String
end
