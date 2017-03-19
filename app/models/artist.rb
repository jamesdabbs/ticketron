class Artist < Dry::Struct
  attribute :id,          T::Int.optional
  attribute :name,        T::String
  attribute :spotify_id,  T::String.optional
  attribute :songkick_id, T::String
end
