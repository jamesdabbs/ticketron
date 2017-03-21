class ProcessMailJob < ApplicationJob
  queue_as :mail

  def perform mail:
    container.mail_handler.call mail: mail
  end
end
