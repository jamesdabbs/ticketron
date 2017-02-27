class Concert < ApplicationRecord
  belongs_to :venue

  has_many :concert_artists
  has_many :artists, through: :concert_artists

  has_many :concert_attendees
  has_many :attendees, through: :concert_attendees, source: :user

  scope :upcoming, -> { where 'at > ?', 1.day.ago }
  scope :in_month, ->(date) { where 'at BETWEEN ? AND ?', date.at_beginning_of_month, date.at_end_of_month }

  def add_artist artist
    concert_artists.where(artist: artist).first_or_create!
  end

  def add_attendee user
    concert_attendees.where(user: user).first_or_create!
  end
end
