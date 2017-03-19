# coding: utf-8
module Songkick
  class Scraper
    ConcertNotFound = Class.new StandardError

    def initialize repository:, logger: nil
      @agent      = Mechanize.new
      @logger     = logger || Rails.logger
      @repository = repository
    end

    def find_concert venue:, artists:
      text = "#{artists.join(' ')} #{venue}"
      visit "/search?utf8=✓&type=initial&query=#{text}"
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

    def import concert_id
      visit "/concerts/#{concert_id}"

      link  = page.css('.event-header .name a')
      venue = add_venue name: link.text, url: link.attribute('href').value

      date = DateTime.parse page.css('.event-header .date-and-name').text.strip
      concert = add_concert venue, id: concert_id, date: date
      return concert if concert.artists.any? # already imported

      page.css('.event-header .line-up a').each do |link|
        artist = add_artist name: link.text, url: link.attribute('href').value
        concert.add_artist artist
      end

      concert
    end

    private

    # TODO: remove reference to @user, models

    attr_reader :page, :logger

    def visit path
      @page = @agent.get "https://www.songkick.com#{path}"
    end

    def add_venue name:, url:
      DB::Venue.where(songkick_id: id(url)).first_or_create! do |v|
        v.name = name
      end
    end

    def add_concert venue, id:, date:
      DB::Concert.where(songkick_id: id).first_or_create! do |c|
        c.venue = venue
        c.at    = date
      end
    end

    def add_artist name:, url:
      DB::Artist.where(songkick_id: id(url)).first_or_create! do |a|
        a.name = name
        Spotify::ScanArtistJob.perform_later id(url)
      end
    end

    def id url
      url =~ /\/(\d+)\-/ && $1
    end
  end
end
