module Mail
  module Parser
    class Ticketmaster
      def call mail
        return unless mail.text.include? 'ticketmaster.com'

        lines = mail.text.split("\n").map(&:strip).reject(&:empty?)

        while line = lines.shift
          break if line.start_with? 'Order #'
        end

        while line = lines.shift
          next if line.start_with? '<http'
          next if line.length < 2
          break
        end

        artist = line
        venue  = lines.shift
        #date   = Date.parse lines.shift

        delivery_method = if lines.include? '*Print-at-Home*'
          Tickets::Print
        end

        Mail::Parser::Result.new \
          venue:   venue,
          artists: [artist],
          tickets: nil, # TODO
          method:  delivery_method
      end
    end
  end
end
