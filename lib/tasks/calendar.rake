namespace :calendar do
  desc 'Sync Google calendars for all users'
  task :sync => :environment do
    DB::Identity.where(provider: Identity::Spotify).find_each do |id|
      Google::CalendarSyncJob.perform_later user: id.user
    end
  end
end
