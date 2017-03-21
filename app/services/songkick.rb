class Songkick < Gestalt[:remote, :repository]
  NotSynced       = Class.new StandardError
  ConcertNotFound = Class.new StandardError

  MightGo = :might_go
  Going   = :going

  def self.build repository: nil
    new \
      remote:     Songkickr::Remote.new(Figaro.env.songkick_api_key!),
      repository: repository || Repository.new
  end

  def find_venue name
    result = remote.venue_search(query: name).results.first
    repository.ensure_venue \
      songkick_id: result.id,
      name:        result.display_name
  end

  def find_artist artists
    # For e.g. artists = ['Terminal West Presents:', 'WHY?']
    artists.each do |a|
      if found = remote.artist_search(artists.first).results.first
        return found
      end
    end
    raise ConcertNotFound
  end


  def find_concert venue:, artists:, date:
    artist = find_artist artists
    date_str = date.strftime '%Y-%m-%d'

    event = remote.
      artist_events(artist.id, min_date: date_str, max_date: date_str).
      results.first

    unless event
      raise Songkick::ConcertNotFound
    end

    ensure_event event
  end

  def upcoming_events user:
    remote.
      users_attendance_calendar(user.songkick.username).
      results.
      each_with_object({}) do |result, h|
        h[ensure_event result.event] = {
          "i_might_go" => MightGo,
          "im_going"   => Going
        }.fetch(result.reason)
    end
  end

  private

  def ensure_event event
    repository.ensure_concert \
      venue: {
        songkick_id: event.venue.id,
        name:        event.venue.display_name
      },
      artists: event.performances.map { |a|
        {
          songkick_id: a.id,
          name:        a.display_name
        }
      },
      songkick_id: event.id,
      at:          event.start
  end
end
