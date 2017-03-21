class TicketMailer < ApplicationMailer
  def email_unhandled email:
    @email = email
  end

  def email_concert_not_found email:
    @email = email
  end
end
