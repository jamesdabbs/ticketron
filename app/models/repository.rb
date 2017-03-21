class Repository
  UserNotFound = Class.new StandardError

  module Helpers
    def next_concert_for user:
      upcoming_concerts(users: [user], limit: 1).first
    end

    def other_upcoming user:, concert:
      upcoming_concerts(user: user).
        select { |c| c.at.month == concert.at.month && c != concert }
    end
  end
  include Helpers

  # ~~ Users ~~
  def user_for_email email, name:
    address = DB::EmailAddress.where(email: email).first_or_initialize
    address.user      ||= User.new
    address.user.name ||= name
    address.user.save!
    address.save!
    address.user
  end

  def user_for_voice_request request
    token = request.request['data']['user']['access_token']
    token = Doorkeeper::AccessToken.by_token token
    return unless token
    User.find_by id: token.resource_owner_id
  end

  def find_auth user:, provider:
    id = Identity.find_by user: user, provider: provider
    id && id.data
  end

  def attach_identity user:, provider:, auth:
    id = Identity.where(user: user, provider: provider).first_or_initialize
    id.data = auth.to_h
    id.save!
    id
  end

  def update_credentials user:, provider:, credentials:
    id = Identity.find_by! user: user, provider: provider
    auth = id.data
    auth.credentials = credentials
    id.data = auth
    id.save!
  end

  # ~~ Venues ~~
  def ensure_venue songkick_id:, name:
    DB::Venue.
      where(songkick_id: songkick_id).
      create_with(name: name).
      first_or_create!.
      to_model
  end

  # ~~ Concerts ~~
  def ensure_concert venue:, artists:, songkick_id:, at:
    if c = DB::Concert.find_by(songkick_id: songkick_id)
      return c.to_model
    end

    v = create_songkick DB::Venue, venue

    c = create_songkick DB::Concert,
      songkick_id: songkick_id,
      venue:       v,
      at:          at

    artists.each do |artist|
      a = create_songkick DB::Artist, artist
      DB::ConcertArtist.where(concert: c, artist: a).first_or_create!

      Spotify::ScanArtistJob.perform_later songkick_id: a.songkick_id
    end

    c.to_model
  end

  def upcoming_concerts users:, limit: nil
    scope = DB::ConcertAttendee.
      joins(:concert).
      includes(:user, concert: [:artists, :venue]).
      where(user_id: users.map(&:id)).
      where('concerts.at > ?', Time.now)
    scope = scope.limit limit if limit

    scope.
      group_by(&:concert).
      map { |concert, attendees| concert.to_model attendees: attendees }.
      sort_by(&:at)
  end


  # ~~ Tickets ~~
  def add_tickets user:, concert:, tickets:, method:
    con = DB::Concert.find_by! songkick_id: concert.songkick_id
    att = DB::ConcertAttendee.where(user: user, concert: con).first_or_initialize

    Google::CalendarSyncJob.perform_later user: user

    att.update! number: tickets, status: method
  end

  def tickets_status user:, concert:
    con = DB::Concert.find_by! songkick_id: concert.songkick_id
    att = DB::ConcertAttendee.find_by user: user, concert: con
    att && att.status
  end

  # ~~ Mail ~~
  def claim_email user:, email:
    address = DB::EmailAddress.find_by(email: email)
    if address && address.user_id != user.id
      raise Email::Taken
    end

    DB::EmailAddress.create! user: user, email: email
  end

  def save_mail from:, to:, subject:, headers:, html:, text:, received_at:
    address = DB::EmailAddress.
      where(email: Email.standardize(from)).
      first_or_create!

    DB::Email.create!(
      email_address: address,
      from:          from,
      to:            to,
      subject:       subject,
      html:          html,
      text:          text,
      created_at:    received_at
    ).to_model
  end

  def mail_from user
    DB::Email.
      joins(:email_address).
      where(email_addresses: { user_id: user.id }).
      includes(:concert).
      map(&:to_model)
  end

  def attach_concert mail:, concert:
    DB::Email.find(mail.id).update! concert: \
      DB::Concert.find_by(songkick_id: concert.songkick_id)
  end

  # ~~ Spotify ~~
  def spotify_playlist user:
    return unless user.spotify_playlist_id
    Playlist.new \
      user_id:   user.spotify_id,
      id:        user.spotify_playlist_id,
      url:       user.spotify_playlist_url,
      synced_at: user.spotify_playlist_synced
  end

  def update_spotify user:, user_id: nil, id: nil, url: nil, synced: nil
    updates = {
      spotify_id:              user_id,
      spotify_playlist_id:     id,
      spotify_playlist_url:    url,
      spotify_playlist_synced: synced
    }.select { |_,v| v.present? }

    user.update! updates
  end

  def update_spotify_id artist:, spotify_id:
    DB::Artist.find(artist.id).update! spotify_id: spotify_id
  end

  # ~~ Google ~~
  def google_calendar_synced user:
    user.update! google_calendar_synced: Time.now
  end

  # ~~ Songick ~~
  def update_songkick user:, username:
    User.find(user.id).update! songkick_username: username
  end

  private

  def friends_of user:
    Friendship.
      where('from_id = ? OR to_id = ?', user.id, user.id).
      where('approved_at IS NOT NULL').
      pluck(:from_id, :to_id).
      flatten.
      uniq
  end

  def create_songkick model, songkick_id:, **opts
    model.
      where(songkick_id: songkick_id).
      create_with(**opts).
      first_or_create!
  end
end
