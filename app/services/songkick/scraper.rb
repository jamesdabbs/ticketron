module Songkick
  class Scraper
    def initialize user:, logger: nil
      @user   = user
      @agent  = Mechanize.new
      @logger = logger || Rails.logger
    end

    def import concert_id
      @logger.info "Adding concert #{concert_id}"
      visit "/concerts/#{concert_id}"

      link  = page.css('.event-header .name a')
      venue = add_venue name: link.text, url: link.attribute('href').value

      date = DateTime.parse page.css('.event-header .date-and-name').text.strip
      concert = add_concert venue, id: concert_id, date: date

      page.css('.event-header .line-up a').each do |link|
        artist = add_artist name: link.text, url: link.attribute('href').value
        concert.add_artist artist
      end
    end

    private

    attr_reader :page

    def visit path
      @page = @agent.get "https://www.songkick.com#{path}"
    end

    def add_venue name:, url:
      Venue.where(songkick_id: id(url)).first_or_create! do |v|
        v.name = name
      end
    end

    def add_concert venue, id:, date:
      Concert.where(songkick_id: id).first_or_create! do |c|
        c.venue = venue
        c.at    = date
      end.tap do |c|
        c.add_attendee @user
      end
    end

    def add_artist name:, url:
      Artist.where(songkick_id: id(url)).first_or_create! do |a|
        a.name = name
      end
    end

    def id url
      url =~ /\/(\d+)\-/ && $1
    end
  end
end
