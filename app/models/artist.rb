class Artist < Dry::Struct
  attribute :name,        T::String
  attribute :songkick_id, T::String
  attribute :spotify_id,  T::String.optional
end
