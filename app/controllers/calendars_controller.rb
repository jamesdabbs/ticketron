class CalendarsController < ApplicationController
  def update
    identity = repo.identity user: current_user, provider: 'google_oauth2'
    container.google_calendar_sync.call user: current_user, auth: identity.data
    redirect_back fallback_location: profile_path, success: 'Synced with Google calendar'
  end
end
