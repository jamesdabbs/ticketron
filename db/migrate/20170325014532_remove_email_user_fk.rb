class RemoveEmailUserFk < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :email_addresses, :users
  end
end
