class Songkick
  class EventSync < Gestalt[:repository, :songkick]
    def call user:
      songkick.upcoming_events(user: user).each do |concert, _status|
        # TODO:
        # * only set method to order if we don't already have tickets
        # * record that we have RSVP'd on Songkick
        repository.add_tickets \
          user:    user,
          concert: concert,
          tickets: 0,
          method:  Tickets::Order
      end
    end
  end
end
