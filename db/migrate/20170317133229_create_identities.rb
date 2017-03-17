class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.belongs_to :user
      t.string :provider
      t.string :uid
      t.json :data

      t.timestamps
    end
  end
end
