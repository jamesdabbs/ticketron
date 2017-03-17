class ProcessMailJob < ApplicationJob
  def perform mail
    container.mail_handler.call mail
  end
end
