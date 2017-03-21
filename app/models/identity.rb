class Identity < ApplicationRecord
  Google  = 'google_oauth2'.freeze
  Spotify = 'spotify'.freeze

  belongs_to :user, optional: true

  validates_uniqueness_of :uid, scope: :provider

  def data
    Hashie::Mash.new self[:data]
  end
end
