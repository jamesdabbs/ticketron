class SyncGoogleCalendarJob < ApplicationJob
  def perform identity
    return unless identity.provider == 'google_oauth2'

    Ticketron.container.google_calendar_sync.call user: identity.user, auth: identity.data
  end
end
