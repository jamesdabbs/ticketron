module Factories
  def build name, **opts
    send "build_#{name}", **opts
  end

  def build_request **opts
    instance_double Voice::Request, **opts
  end

  def build_concert **opts
    instance_double Concert, Hashie::Mash.new({
      artists: [
        { name: 'Daughters' }
      ],
      venue: { name: '9:30 Club' },
      at: 3.weeks.from_now
    }.merge(opts))
  end

  def build_user **opts
    defaults User, opts, email: 'test@example.com'
  end

  def build_artist **opts
    defaults Artist, opts, \
      id:          rand(1 .. 1_000_000),
      name:        'Portugal the Man',
      spotify_id:  rand(1 .. 1_000_000),
      songkick_id: rand(1 .. 1_000_000)
  end

  def build_venue **opts
    defaults Venue, opts, \
      name:        '9:30 Club',
      songkick_id: rand(1 .. 1_000_000)
  end

  def build_mail **opts
    defaults Mail, opts
  end

  private

  def defaults klass, overrides, **defs
    klass.new defs.merge overrides
  end
end

RSpec.configure do |config|
  config.include Factories
end
