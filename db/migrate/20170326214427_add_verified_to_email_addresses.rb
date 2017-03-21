class AddVerifiedToEmailAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :email_addresses, :verified, :boolean, null: false, default: false
  end
end
