class User < ApplicationRecord
  devise :rememberable, :trackable, :doorkeeper,
         :omniauthable, omniauth_providers: [:spotify, :google_oauth2]

  has_many :email_addresses, class_name: 'DB::EmailAddress'

  validates :name, presence: true

  class Struct < Dry::Struct
    attribute :id,         T::String
    attribute :name,       T::String
    attribute :emails,     T::Array.member(Object)
    attribute :avatar_url, T::String
    attribute :google,     Object
    attribute :songkick,   Object
    attribute :spotify,    Object
  end

  def to_model
    User::Struct.new \
      id:         id,
      name:       name,
      emails:     email_addresses.map(&:to_model),
      avatar_url: image_url,
      google:     google,
      songkick:   songkick,
      spotify:    spotify
  end

  def google
    Hashie::Mash.new \
      email:           'FIXME',
      calendar_synced: google_calendar_synced
  end

  def spotify
    Hashie::Mash.new \
      user_id:         spotify_id,
      playlist_id:     spotify_playlist_id,
      playlist_url:    spotify_playlist_url,
      playlist_synced: spotify_playlist_synced
  end

  def songkick
    Hashie::Mash.new username: songkick_username
  end
end
