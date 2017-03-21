module Mail
  class Handler < Gestalt[:parsers, :repository, :notifier, :songkick]
    Unhandled = Class.new StandardError

    def call mail:
      parsed = parse_email mail

      repository.add_tickets \
        user:    mail.user,
        concert: parsed.concert,
        tickets: parsed.tickets,
        method:  parsed.method

      repository.attach_concert mail: mail, concert: parsed.concert
    rescue Mail::Handler::Unhandled
      notifier.email_unhandled email: mail
    rescue Songkick::ConcertNotFound
      notifier.email_concert_not_found email: mail
    end

    private

    def parse_email mail
      parsers.each do |parser|
        result = parser.call mail: mail
        return result if result
      end
      raise Unhandled
    end
  end
end
