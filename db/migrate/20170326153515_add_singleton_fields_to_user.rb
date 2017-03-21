class AddSingletonFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :spotify_id, :string
    add_column :users, :spotify_playlist_id, :string
    add_column :users, :spotify_playlist_url, :string
    add_column :users, :spotify_playlist_synced, :datetime
    add_column :users, :songkick_username, :string
    add_column :users, :google_calendar_synced, :datetime

    remove_column :users, :meta
    remove_column :identities, :store
  end
end
