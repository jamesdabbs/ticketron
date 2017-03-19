class SetAvatars < ActiveRecord::Migration[5.0]
  def change
    Identity.where(provider: 'spotify').find_each do |i|
      u = i.user
      u.image_url = i.data.info.image
      u.save!
    end
  end
end
