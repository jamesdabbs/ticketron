module Voice::Handlers
  module Helpers
    include ActionView::Helpers::TextHelper

    def describe_concert concert
      artists = concert.artists.map(&:name)
      "#{artists.to_sentence} at #{concert.venue.name}"
    end

    def date dt
      month = dt.strftime '%B'
      day   = dt.strftime('%d').to_i.ordinalize
      "#{month} #{day}"
    end

    def require_user! request
      repository.user_for_voice_request(request) || raise(Voice::Dispatch::UserNotFound)
    end
  end
end
