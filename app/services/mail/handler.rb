class Mail
  class Handler < Gestalt[:parsers, :repository, :notifier, :songkick]
    Unhandled = Class.new StandardError

    def call mail
      user = repository.user_by_email mail.from

      parsed = parse_email mail

      concert = songkick.find_concert \
        venue:   parsed.venue,
        artists: parsed.artists

      repository.add_tickets \
        user:    user,
        concert: concert,
        tickets: parsed.tickets,
        method:  parsed.method

      repository.attach_concert mail: mail, concert: concert
    rescue Repository::UserNotFound
      notifier.email_account_not_found email: mail
    rescue Mail::Handler::Unhandled
      notifier.email_unhandled user: user, email: mail
    rescue Songkick::Scraper::ConcertNotFound
      notifier.email_concert_not_found user: user, email: mail
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
