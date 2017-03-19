class DB::Artist < ApplicationRecord
  def to_model
    ::Artist.new \
      id:          id,
      name:        name,
      spotify_id:  spotify_id,
      songkick_id: songkick_id
  end
end
