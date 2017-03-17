class User < ApplicationRecord
  devise :rememberable, :trackable, :doorkeeper,
         :omniauthable, omniauth_providers: [:spotify, :google_oauth2]

  has_many :concert_attendees
  has_many :concerts, through: :concert_attendees

  def self.from_spotify auth:
    u = where(spotify_id: auth.uid).first_or_initialize
    u.spotify_data = auth.to_h

    u.email = auth.extra.raw_info.email unless u.email.present?

    u.save!
    u
  end

  def spotify_token
    spotify_data.fetch('credentials').fetch('token')
  end

  def spotify
    @spotify ||= Spotify::Client.new(access_token: spotify_token)
  end

  def country # TODO
    'us'
  end
end
