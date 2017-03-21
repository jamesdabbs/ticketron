class Container
  def initialize inner=nil, &block
    @inner = inner || Gestalt::Container.new(&block)
    @inner.freeze
  end

  def with &configuration
    self.class.new @inner.with(&configuration)
  end

  def method_missing name, *args
    resolved = @inner.resolve name
    if args.any? && resolved.respond_to?(:call)
      resolved.call(*args)
    else
      resolved
    end
  end

  def self.build
    new do |c|
      c.http       { HTTP.new }
      c.repository { Repository.new }
      c.notifier   { Notifier.new }

      c.google_calendar_builder do
        ->(auth) { Google::Calendar.new auth }
      end
      c.google_calendar_sync do
        Google::CalendarSync.new \
          build_calendar: c.google_calendar_builder,
          repository:     c.repository
      end

      c.mail_receiver do
        Mail::Receiver.build \
          repository: c.repository,
          handler:    ->(mail) { ProcessMailJob.perform_later mail: mail }
      end
      c.mail_handler do
        Mail::Handler.new \
          parsers: [
            Mail::Parser::Ticketfly.new(songkick: c.songkick)
          ],
          repository: c.repository,
          notifier:   c.notifier,
          songkick:   c.songkick
      end

      c.songkick { Songkick.build repository: c.repository }
      c.songkick_event_sync do
        Songkick::EventSync.new \
          repository: c.repository,
          songkick: c.songkick
      end

      c.spotify_client_builder do
        Spotify::ClientBuilder.new repository: c.repository, http: c.http
      end
      c.spotify_login do
        Spotify::Login.new repository: c.repository
      end
      c.spotify_scanner do
        Spotify::Scanner.new repository: c.repository
      end
      c.spotify_playlist_finder do
        Spotify::PlaylistFinder.new \
          repository:     c.repository,
          client_builder: c.spotify_client_builder
      end
      c.spotify_playlist_generator do
        Spotify::PlaylistGenerator.new \
          repository:     c.repository,
          client_builder: c.spotify_client_builder,
          finder:         c.spotify_playlist_finder,
          scanner:        c.spotify_scanner
      end

      c.voice do
        Voice::Dispatch.new \
          'concerts.upcoming' => Voice::Handlers::UpcomingConcerts.new(repository: c.repository),
          'concerts.detail'   => Voice::Handlers::ConcertCheck.new(repository: c.repository)
      end
    end
  end
end
