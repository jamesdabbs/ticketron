class NullObject
  def method_missing *args
    self
  end
end

module Factories
  def build name, **opts
    send "build_#{name}", **opts
  end

  def build_request **opts
    instance_double Voice::Request, **opts
  end

  def build_concert **opts
    defaults Concert, opts,
      venue:       build(:venue, name: '9:30 Club'),
      artists:     [ build(:artist, name: 'Daughters') ],
      songkick_id: id,
      at:          3.weeks.from_now
  end

  def build_user **opts
    _id = id
    defaults User::Struct, opts,
      id:         _id,
      name:       "User #{_id}",
      emails:     ["user#{_id}@example.com"],
      avatar_url: "http://image.example.com/#{_id}",
      google:     nil,
      spotify:    nil,
      songkick:   nil
  end

  def build_tickets **opts
    defaults Tickets, opts,
      user:   build(:user),
      number: rand(1 .. 6),
      status: Tickets::STATUSES.values.sample
  end

  def build_artist **opts
    defaults Artist, opts,
      id:          id,
      name:        'Portugal the Man',
      spotify_id:  id,
      songkick_id: id
  end

  def build_venue **opts
    defaults Venue, opts,
      name:        '9:30 Club',
      songkick_id: id
  end

  def build_mail **opts
    defaults Email, opts,
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

  def build_playlist **opts
    defaults Playlist, opts,
      user_id:    id,
      id:         id,
      spotify_id: id,
      url:        'http://example.com/playlist',
      synced_at:  2.days.ago
  end

  def _
    NullObject.new
  end

  private

  def defaults klass, overrides, **defs
    klass.new defs.merge overrides
  end

  def id
    rand 1 .. 1_000_000
  end
end

class Builder
  include Factories
end

RSpec.configure do |config|
  config.include Factories
end
