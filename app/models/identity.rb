class Identity < ApplicationRecord
  belongs_to :user, optional: true

  validates_uniqueness_of :uid, scope: :provider

  def self.oauthorized auth, user:
    Identity.where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |id|
      id.data = auth.to_h
      id.user = user if user
      id.save!
    end
  end

  def data
    Hashie::Mash.new self[:data]
  end
end
