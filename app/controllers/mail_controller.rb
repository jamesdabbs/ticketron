class MailController < ApiController
  def create
    # FIXME: need to verify sender authenticity
    container.mail_receiver.call params
  rescue
  ensure
    head :ok
  end
end
