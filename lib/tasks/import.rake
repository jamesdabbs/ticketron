task :import => :environment do
  container = Ticketron.container
  repo      = container.repository

  receiver = Mail::Receiver.build \
    repository: repo,
    handler:    ->(mail) { ProcessMailJob.new.perform mail: mail }

  puts 'Importing mail ...'
  Dir['db/mail/*.json'].each do |path|
    puts "Handling #{path}"
    json = JSON.parse File.read path
    receiver.call ActionController::Parameters.new(json)
  end

  puts 'Syncing with Songkick ...'
  user = repo.user_for_email 'jamesdabbs@gmail.com', name: 'James Dabbs'
  repo.update_songkick user: user, username: 'jdabbs'
  container.songkick_event_sync user: user
  puts

  puts 'Upcoming concerts'
  repo.upcoming_concerts(users: [user]).each do |concert|
    puts Cli::ConcertPresenter.new(concert).description
  end
end
