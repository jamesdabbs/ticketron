class DB::Email < ApplicationRecord
  belongs_to :email_address, class_name: 'DB::EmailAddress'
  belongs_to :concert, required: false, class_name: 'DB::Concert'

  def to_model
    ::Email.new \
      id:          id,
      concert:     concert && concert.to_model,
      from:        from,
      to:          to,
      subject:     subject,
      html:        html,
      text:        text,
      received_at: created_at
  end
end
