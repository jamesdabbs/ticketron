module Mail
  module Parser
    class Ticketfly < Gestalt[:songkick]
      def call mail:
        return unless mail.subject =~ /Your Ticketfly Order/i

        _songkick = songkick
        Mail::Scanner.scan mail.text do
          scan_to(/^Event Information/)

          artists, date = scan_to { |l| Date.parse(l) rescue nil }

          scan_to(/Doors:/)

          location, _ = scan_to(/Map/)

          venue    = location.shift
          _address = location.join "\n"

          scan_to(/^Order Details/)

          concert = _songkick.find_concert venue: venue, artists: artists, date: date

          _, ticket_count = scan_to { |l| l =~ /^(\d+) tickets/ && Integer($1) }

          _, method = scan_to { |l| l =~ /^Delivery method (.*)/i && $1 }

          delivery_method = {
            'Will Call'     => Tickets::WillCall,
            'Standard Mail' => Tickets::ByMail
          }.fetch(method)

          Mail::Parser::Result.new \
            concert: concert,
            tickets: ticket_count,
            method:  delivery_method
        end
      end
    end
  end
end
