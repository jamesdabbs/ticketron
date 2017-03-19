class Repository
  UserNotFound = Class.new StandardError

  def ensure_user email:, default_name: nil
    email   = strip_email email
    address = DB::EmailAddress.where(email: email).first_or_create!
    unless address.user
      default_name ||= email.split('@').first
      address.user = User.where(name: default_name).create!
      address.save!
    end
    address.user
  end

  def attach_identity user:, identity:
    identity.update! user: user
  end

  def identity user:, provider:
    Identity.find_by(user: user, provider: provider)
  end

  def update_credentials identity:, credentials:
    data = identity.data.as_json
    data['credentials']['token']      = credentials['access_token']
    data['credentials']['expires_at'] = Time.now + credentials['expires_in']
    identity.update! data: data
  end

  def user_by_email email
    email = strip_email email
    address = DB::EmailAddress.find_by email: email
    if address && address.user
      address.user
    else
      raise UserNotFound.new email
    end
  end

  def add_tickets user:, concert:, tickets: 1, method:
    con = DB::Concert.find_by! songkick_id: concert.songkick_id
    att = DB::ConcertAttendee.where(user: user, concert: con).first_or_initialize
    att.update! number: tickets, status: method
  end

  def user_for_voice_request request
    token = request.request['data']['user']['access_token']
    token = Doorkeeper::AccessToken.by_token token
    return unless token
    User.find_by id: token.resource_owner_id
  end

  def next_concert_for user:
    # TODO: this doesn't need to fetch all concerts
    upcoming_concerts(user: user).first
  end

  def tickets_status user:, concert:
    att = DB::ConcertAttendee.find_by user: user, concert: concert
    att && att.status
  end

  def upcoming_concerts user:
    user_ids = [user.id] + friends_of(user: user)

    DB::ConcertAttendee.
      joins(:concert).
      includes(:user, concert: [:artists, :venue]).
      where(user_id: user_ids).
      where('concerts.at > ?', Time.now).
      group_by(&:concert).
      map { |concert, attendees| concert.to_model attendees: attendees }.
      sort_by(&:at)
  end

  def other_upcoming user:, concert:
    upcoming_concerts(user: user).
      select { |c| c.at.month == concert.at.month && c != concert }
  end

  def concert_by_name user:, name:
    ConcertResolver.new.call(concerts: upcoming_concerts(user: user), query: name).first
  end

  def create_mail **opts
    opts[:email_address] = resolve_email opts[:from]
    DB::Email.create!(**opts)
  end

  def find_mail id:
    DB::Email.find params[:id]
  end

  def last_mail
    Email.last
  end

  def user_by_spotify_id id
    User.find_by! spotify_id: id
  end

  def mail_from user
    DB::Email.
      joins(:email_address).
      where(email_addresses: { user: user }).
      includes(:concert).
      map(&:to_model)
  end

  def attach_concert mail:, concert:
    mail.update! concert: concert
  end

  def resolve_email email
    email   = strip_email email
    address = DB::EmailAddress.where(email: email).first_or_create!
    unless address.user
      address.update! user: User.create!(name: email.split('@').first)
    end
    address
  end

  def update_spotify_id artist:, spotify_id:
    DB::Artist.find(artist.id).update! spotify_id: spotify_id
  end

  def spotify_playlist user:
    spotify = user.meta.spotify
    return unless spotify && spotify.playlist_id
    Playlist.new \
      user_id:   spotify.user_id,
      id:        spotify.playlist_id,
      url:       spotify.playlist_url,
      synced_at: spotify.playlist_synced
  end

  def record_spotify_playlist user:, user_id:, playlist_id:, playlist_url:
    add_metadata user, spotify: {
      user_id:      user_id,
      playlist_id:  playlist_id,
      playlist_url: playlist_url
    }
  end

  def spotify_playlist_updated user:
    add_metadata user, spotify: { playlist_synced: Time.now }
  end

  def google_calendar_synced user:
    add_metadata user, google: { calendar_synced: Time.now }
  end

  def get_concert songkick_id:
    DB::Concert.find_by(songkick_id: songkick_id).try :to_model
  end

  def create_concert concert
    raise NotImplemented
  end

  private

  def add_metadata user, updates
    user.update! meta: user.meta.deep_merge(Hashie::Mash.new updates).as_json
  end

  def friends_of user:
    Friendship.
      where('from_id = ? OR to_id = ?', user.id, user.id).
      where('approved_at IS NOT NULL').
      pluck(:from_id, :to_id).
      flatten.
      uniq
  end

  def upcoming_attends user:
    DB::ConcertAttendee.
      joins(:concert).
      includes(concert: [:artists, :venue]).
      where(user_id: user).
      where('concerts.at > ?', Time.now).
      order('concerts.at asc')
  end

  def strip_email email
    email =~ /<([^>]+)>/ ? $1 : email
  end
end
