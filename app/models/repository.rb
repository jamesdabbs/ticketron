class Repository
  UserNotFound = Class.new StandardError

  def user_by_email email
    email = strip_email email
    User.find_by(email: email) || raise(UserNotFound.new email)
  end

  def add_tickets user:, concert:, tickets:, method:
    att = DB::ConcertAttendee.where(user: user, concert: concert).first_or_initialize
    att.update! number: tickets, status: method
  end

  def user_for_voice_request request
    token = request.request['data']['user']['access_token']
    token = Doorkeeper::AccessToken.by_token token
    return unless token
    User.find_by id: token.resource_owner_id
  end

  def next_concert_for user:
    attend = upcoming_attends(user: user).first
    ::Concert.from_attendee attend
  end

  def tickets_status user:, concert:
    att = DB::ConcertAttendee.find_by user: user, concert: concert
    att && att.status
  end

  def all_upcoming_concerts
    DB::Concert.
      includes([:artists, :venue]).
      where('at > ?', Time.now).
      order(at: :asc).map { |c| ::Concert.from_db c }
  end

  def upcoming_concerts user:
    upcoming_attends(user: user).map { |attend| ::Concert.from_attendee attend }
  end

  def other_upcoming user:, concert:
    upcoming_concerts(user: user).
      select { |c| c.at.month == concert.at.month && c != concert }
  end

  def concert_by_name user:, name:
    ConcertResolver.new.call(concerts: upcoming_concerts(user: user), query: name).first
  end

  def create_mail **opts
    opts[:user] = resolve_user opts[:from]
    Mail.create!(**opts)
  end

  def last_mail
    Mail.last
  end

  def user_by_spotify_id id
    User.find_by! spotify_id: id
  end

  def mail_from user
    Mail.where(user: user)
  end

  def attach_concert mail:, concert:
    mail.update! concert: concert
  end

  def resolve_user email
    email = strip_email email
    User.find_each do |u|
      if u.spotify_data['info']['email'] == email
        return u
      end
    end
    raise(UserNotFound.new email)
  end

  private

  def upcoming_attends user:
    DB::ConcertAttendee.
      joins(:concert).
      includes(concert: [:artists, :venue]).
      where(user: user).
      where('concerts.at > ?', Time.now).
      order('concerts.at asc')
  end

  def strip_email email
    email =~ /<([^>]+)>/ ? $1 : email
  end
end
