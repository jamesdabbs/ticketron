module Voice::Handlers
  class ConcertCheck < Gestalt[:repository, :concert_finder]
    include Helpers

    def call request
      user = require_user! request

      concert = concert_finder.call user: user, name: request.params[:concert]

      text = ["Your concert for #{describe_concert concert} is on #{date concert.at}"]

      tickets = repository.tickets_status user: user, concert: concert
      if tickets
        text << tickets.description
      end

      Voice::Response.text text.join('. ')
    end
  end
end
