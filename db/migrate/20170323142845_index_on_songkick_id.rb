class IndexOnSongkickId < ActiveRecord::Migration[5.0]
  def change
    add_index :concerts, :songkick_id
    add_index :artists, :songkick_id
    add_index :venues, :songkick_id
  end
end
