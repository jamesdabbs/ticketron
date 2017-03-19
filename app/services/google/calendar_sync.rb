module Google
  class CalendarSync < Gestalt[:repository]
    def call user:, auth:
      service = Google::Calendar.new auth

      calendar = service.list_calendars['items'].find { |c| c['summary'] == 'Ticketron' }
      unless calendar
        service.insert_calendar 'Ticketron'
        calendar = service.list_calendars['items'].find { |c| c['summary'] == 'Ticketron' }
      end

      cal_id   = calendar.fetch 'id'
      existing = service.list_events(cal_id).fetch('items').map { |i| i['description'] }

      repository.upcoming_concerts(user: user).each do |concert|
        tickets = concert.attendees.find { |t| t.user == user }
        next unless tickets

        next if existing.any? { |desc| desc.include? concert.songkick_id }
        url = "https://ticketron.herokuapp.com/concerts/#{concert.songkick_id}"

        service.insert_event cal_id,
          summary:     concert.artists.map(&:name).to_sentence,
          location:    concert.venue.name,
          start:       { dateTime: concert.at },
          end:         { dateTime: concert.at + 3.hours },
          description: url
      end

      repository.google_calendar_synced user: user
    end
  end
end
