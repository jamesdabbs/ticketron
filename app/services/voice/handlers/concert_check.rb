module Voice::Handlers
  class ConcertCheck < Gestalt[:repository]
    include Helpers

    def call request
      user = require_user! request

      concert_name = request.params[:concert]
      concert = repository.concert_by_name user: user, name: concert_name

      text = ["Your concert for #{describe_concert concert} is on #{date concert.at}"]

      tickets = repository.tickets_status user: user, concert: concert
      if tickets
        text << tickets.description
      end

      Voice::Response.text text.join('. ')
    end
  end
end
