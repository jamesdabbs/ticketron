class Mail < ApplicationRecord
  belongs_to :user,    required: false
  belongs_to :concert, required: false, class_name: 'DB::Concert'
end
