class AddFieldsToConcertAttendees < ActiveRecord::Migration[5.0]
  def change
    add_column :concert_attendees, :number, :integer
    add_column :concert_attendees, :status, :string
    remove_column :concert_attendees, :tickets, :json
  end
end
