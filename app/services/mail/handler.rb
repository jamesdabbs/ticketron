module Mail
  class Handler < Gestalt[:parsers, :repository, :notifier, :songkick]
    Unhandled = Class.new StandardError

    def call mail
      parsed = parse_email mail

      concert = songkick.find_concert \
        venue:   parsed.venue,
        artists: parsed.artists

      repository.add_tickets \
        user:    mail.user,
        concert: concert,
        tickets: parsed.tickets,
        method:  parsed.method

      repository.attach_concert mail: mail, concert: concert
    rescue Mail::Handler::Unhandled
      notifier.email_unhandled email: mail
    rescue Songkick::Scraper::ConcertNotFound
      notifier.email_concert_not_found email: mail
    end

    private

    def parse_email mail
      parsers.each do |parser|
        result = parser.call mail
        return result if result
      end
      raise Unhandled
    end
  end
end
