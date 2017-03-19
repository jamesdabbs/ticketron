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
    }.deep_merge(opts))
  end

  def build_user **opts
    defaults User, opts, name: 'Test User'
  end

  def build_artist **opts
    defaults Artist, opts, \
      id:          id,
      name:        'Portugal the Man',
      spotify_id:  id,
      songkick_id: id
  end

  def build_venue **opts
    defaults Venue, opts, \
      name:        '9:30 Club',
      songkick_id: id
  end

  def build_mail **opts
    defaults Email, opts, \
      id:          id,
      user:        build(:user),
      concert:     nil,
      from:        'from@example.com',
      to:          'to@example.com',
      subject:     'subject',
      html:        '',
      text:        '',
      received_at: 3.minutes.ago
  end

  private

  def defaults klass, overrides, **defs
    klass.new defs.merge overrides
  end

  def id
    rand 1 .. 1_000_000
  end
end

RSpec.configure do |config|
  config.include Factories
end
