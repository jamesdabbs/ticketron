# user = User.new spotify_id: 'jamesdabbs'
# user.save! validate: false

Doorkeeper::Application.create! \
  name:         'Google',
  uid:          Figaro.env.google_client_id!,
  secret:       Figaro.env.google_client_secret!,
  redirect_uri: "https://oauth-redirect.googleusercontent.com/r/#{Figaro.env.google_project_id!}"

sk = Songkick::Scraper.new repository: Repository.new, logger: Logger.new(STDOUT)
import = ->(id) do
  puts "Importing #{id}"
  sk.import id
  # concert.concert_attendees.create! user: user
end

import.('28733214')
import.('28528294')
import.('29159124')
import.('29040569')
import.('29220299')
import.('28966259')
import.('29377334')

