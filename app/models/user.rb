class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:spotify]

  has_many :concert_attendees
  has_many :concerts, through: :concert_attendees

  def self.from_spotify auth:
    u = where(spotify_id: auth.uid).first_or_initialize
    u.spotify_data = auth.to_h

    u.email    = auth.extra.raw_info.email unless u.email.present?
    u.password = SecureRandom.hex 32 unless u.password.present?

    u.save!
    u
  end

  def spotify_token
    spotify_data.fetch('credentials').fetch('token')
  end

  def spotify
    @spotify ||= Spotify::Client.new(access_token: spotify_token)
  end

  def upcoming_artists
    concerts.where('at > ?', 1.day.ago).includes(:artists).
      map(&:artists).flatten.uniq
  end

  def country # TODO
    'us'
  end
end
