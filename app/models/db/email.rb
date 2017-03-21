class DB::Email < ApplicationRecord
  self.table_name = 'mails'

  belongs_to :email_address, class_name: 'DB::EmailAddress'
  belongs_to :concert, required: false, class_name: 'DB::Concert'

  def to_model
    ::Email.new \
      id:          id,
      user:        email_address.user,
      concert:     concert && concert.to_model,
      from:        from,
      to:          to,
      subject:     subject,
      html:        html,
      text:        text,
      received_at: created_at
  end
end
