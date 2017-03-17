module Voice::Handlers
  class UpcomingConcerts < Gestalt[:repository]
    include Voice::Handlers::Helpers

    def call request
      user = require_user! request

      concert = repository.next_concert_for user: user
      if concert.nil?
        return Voice::Response.text 'You have no upcoming concerts'
      end

      text = ["Your next concert is #{describe_concert concert} on #{date concert.at}"]

      if tickets = repository.tickets_status(user: user, concert: concert)
        text << tickets.description
      end

      others = repository.other_upcoming(concert: concert, user: user).count
      if others > 0
        month = concert.at.strftime('%B')
        text << " You have #{pluralize others, 'other concert'} in #{month}"
      end

      Voice::Response.text text.join('. ')
    end
  end
end
