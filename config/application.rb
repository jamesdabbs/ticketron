require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ticketron
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end

  def self.container
    if Rails.env.development?
      @_container = nil
    end

    @_container ||= Gestalt::Container.new do |c|
      c.repository { Repository.new }
      c.voice do
        Voice::Dispatch.new \
          'concerts.upcoming' => Voice::Handlers::UpcomingConcerts.new(repository: c.repository),
          'concerts.detail'   => Voice::Handlers::ConcertCheck.new(repository: c.repository)
      end
      c.notifier { Notifier.new }
      c.songkick { Songkick::Scraper.new repository: c.repository }
      c.mail_receiver do
        Mail::Receiver.build \
          repository: c.repository,
          handler:    ->(mail) { ProcessMailJob.perform_later mail }
      end
      c.mail_handler do
        Mail::Handler.new \
          parsers: [
            Mail::Parser::Ticketfly.new,
            Mail::Parser::Ticketmaster.new,
          ],
          repository: c.repository,
          notifier:   c.notifier,
          songkick:   c.songkick
      end
    end
  end
end
