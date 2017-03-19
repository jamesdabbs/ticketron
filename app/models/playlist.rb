class Playlist < Dry::Struct
  attribute :user_id,   T::String
  attribute :id,        T::String
  attribute :url,       T::String
  attribute :synced_at, T::DateTime
end
