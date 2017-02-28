module Voice
  def self.registry
    @registry ||= {}
  end

  def self.register action, klass
    registry[action] = klass
  end

  def self.simple_response text
    {
      source: 'Ticketron',
      speech: text,
      displayText: text,
      data: {
        google: {
          expect_user_response: false,
          is_ssml: false
        }
      }
    }
  end

  class Dispatch
    def initialize
      @handlers = {
        'concerts.upcoming' => Handlers::UpcomingConcerts.new
      }
      @not_found = Handlers::NotFound.new
    end

    def call request
      handler = @handlers[request.action] || @not_found
      handler.call request
    end
  end
end
