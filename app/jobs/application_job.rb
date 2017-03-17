class ApplicationJob < ActiveJob::Base
  def container
    Ticketron.container
  end
end
