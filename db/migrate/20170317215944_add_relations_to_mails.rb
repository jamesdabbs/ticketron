class AddRelationsToMails < ActiveRecord::Migration[5.0]
  def change
    add_reference :mails, :user, foreign_key: true
    add_reference :mails, :concert, foreign_key: true
  end
end
