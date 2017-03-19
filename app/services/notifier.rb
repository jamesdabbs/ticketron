class Notifier
  def logger
    Rails.logger
  end

  def email_unhandled user:, email:
    logger.info "Email unhandled #{email} | #{user}"
  end

  def email_account_not_found email:
    logger.info "Email account not found #{email}"
  end

  def email_concert_not_found user:, email:
    logger.info "Email concert not found #{email} | #{user}"
  end
end
