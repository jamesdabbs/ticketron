class RemoveGoogleUserIdFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :google_user_id, :string
  end
end
