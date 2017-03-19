class User < ApplicationRecord
  devise :rememberable, :trackable, :doorkeeper,
         :omniauthable, omniauth_providers: [:spotify, :google_oauth2]

  has_many :email_addresses, class_name: 'DB::EmailAddress'

  validates :name, presence: true

  def meta
    Hashie::Mash.new self[:meta]
  end
end
