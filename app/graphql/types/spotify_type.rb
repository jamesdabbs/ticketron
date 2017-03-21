Types::SpotifyType = GraphQL::ObjectType.define do
  name 'Spotify'

  field :playlistUrl, types.String do
    resolve ->(obj, args, ctx) {
      obj.playlist_url
    }
  end
  field :lastSynced, types.Float do
    resolve ->(obj, args, ctx) {
      obj.playlist_synced
    }
  end
end
