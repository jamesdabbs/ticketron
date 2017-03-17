class Mail
  module Parser
    class Ticketfly
      def call mail
        return unless mail.subject =~ /Your Ticketfly Order/i

        lines = mail.text.split "\n"

        while line = lines.shift
          break if line == 'Event Information'
        end

        artists, date = [], nil
        while line = lines.shift
          next if line.empty? || line.include?('<http://')

          begin
            date = Date.parse line
            break
          rescue ArgumentError
            artists.push line
          end
        end

        venue = nil
        while line = lines.shift
          next if line.empty? || line.start_with?('Doors:')
          venue = line
          break
        end

        while line = lines.shift
          break if line.start_with?('Order Details')
        end

        ticket_count = nil
        while line = lines.shift
          next unless line =~ /^(\d+) tickets/i
          ticket_count = Integer($1)
          break
        end

        delivery_method = nil
        while line = lines.shift
          next unless line =~ /^Delivery method (.*)/i
          delivery_method = Tickets::STATUSES.fetch({
            'Will Call' => :will_call
          }.fetch($1))
          break
        end

        Mail::Parser::Result.new \
          venue:   venue,
          artists: artists,
          tickets: ticket_count,
          method:  delivery_method
      end
    end
  end
end
