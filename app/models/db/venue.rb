class DB::Venue < ApplicationRecord
  def to_model
    ::Venue.new \
      id:          id,
      name:        name,
      songkick_id: songkick_id
  end
end
