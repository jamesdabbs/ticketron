class CreateMails < ActiveRecord::Migration[5.0]
  def change
    create_table :mails do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.text :html
      t.text :text
      t.text :headers

      t.timestamps
    end
  end
end
