class Friendship < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to,   class_name: 'User'

  def approved?
    approved_at.present?
  end
end
