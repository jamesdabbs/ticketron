require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ticketron
  class Application < Rails::Application
    config.autoload_paths << "#{Rails.root}/lib"

    config.active_job.queue_adapter = :sidekiq

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: :any
      end
    end
  end

  def self.container
    if Rails.env.development?
      Container.build
    else
      @_container ||= Container.build
    end
  end
end
