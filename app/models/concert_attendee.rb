class ConcertAttendee < ApplicationRecord
  belongs_to :concert
  belongs_to :user

  Status = Struct.new :key, :label, :description

  STATUSES = [
    Status.new(:will_call, 'Will Call', 'Tickets are at will call'),
    Status.new(:to_print, 'To Print', 'You will need to print your tickets'),
    Status.new(:to_order, 'To Order', 'You still need to order tickets')
  ].index_by(&:key)

  def status
    tickets = self.tickets || {}
    key     = tickets['status'] || :to_order
    STATUSES.fetch key.to_sym
  end

  def set_status key
    update tickets: { status: key }
  end
end
