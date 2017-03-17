class DB::ConcertArtist < ApplicationRecord
  belongs_to :concert, class_name: 'DB::Concert'
  belongs_to :artist, class_name: 'DB::Artist'
end
