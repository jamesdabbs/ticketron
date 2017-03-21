class DB::EmailAddress < ApplicationRecord
  belongs_to :user

  class Struct < Dry::Struct
    attribute :email,    T::String
    attribute :verified, T::Bool
  end

  def to_model
    DB::EmailAddress::Struct.new(email: email, verified: verified)
  end
end
