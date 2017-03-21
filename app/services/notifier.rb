class Notifier
  def email_unhandled email:
    TicketMailer.email_unhandled email: email
  end

  def email_concert_not_found email:
    TicketMailer.email_concert_not_found email: email
  end
end
