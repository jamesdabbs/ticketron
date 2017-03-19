class Notifier
  def logger
    Rails.logger
  end

  def email_unhandled email:
    logger.info "Email unhandled #{email}"
  end

  def email_account_not_found email:
    logger.info "Email account not found #{email}"
  end

  def email_concert_not_found email:
    logger.info "Email concert not found #{email}"
  end
end
