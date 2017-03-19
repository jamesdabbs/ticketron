# coding: utf-8
module Songkick
  class Scraper < Gestalt[:repository]
    ConcertNotFound = Class.new StandardError

    def self.agent
      @agent ||= Mechanize.new
    end

    def search venue:, artists:
      text = "#{artists.join(' ')} #{venue}"
      page = visit "/search?utf8=✓&type=initial&query=#{text}"
      concerts = page.css('.concert')
      if concerts.any?
        concert_for_link concerts.first.css('a').first
      else
        raise ConcertNotFound
      end
    end

    def concert_for_link a
      url = a.attribute('href').value
      import id(url)
    end

    def parse concert_id:
      page = visit "/concerts/#{concert_id}"

      date  = DateTime.parse page.css('.event-header .date-and-name').text.strip
      link  = page.css('.event-header .name a')
      venue = Venue.new \
        name:        link.text,
        songkick_id: id(link.attribute('href').value)

      artists = page.css('.event-header .line-up a').map do |a|
        Artist.new \
          id:          nil,
          name:        a.text,
          spotify_id:  nil,
          songkick_id: id(a.attribute('href').value)
      end

      Concert.new \
        artists:     artists,
        venue:       venue,
        songkick_id: concert_id,
        at:          date,
        attendees:   []
    end

    def import concert_id
      if concert = repository.get_concert(songkick_id: concert_id)
        return concert
      end

      concert = parse concert_id: concert_id

      repository.create_concert concert
    end

    private

    def visit path
      self.class.agent.get "https://www.songkick.com#{path}"
    end

    def add_artist name:, url:
      repository.ensure_artist(name: name, songkick_id: id(url)).tap do |a|
        Spotify::ScanArtistJob.perform_later a.id
      end
    end

    def id url
      url =~ /\/(\d+)\-/ && $1
    end

    def logger
      Rails.logger
    end
  end
end
