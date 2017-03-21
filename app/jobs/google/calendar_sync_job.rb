class Google::CalendarSyncJob < ApplicationJob
  queue_as :sync

  def perform user:
    container.google_calendar_sync.call user: user
  end
end
