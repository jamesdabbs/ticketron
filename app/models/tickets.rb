class Tickets < Dry::Struct
  class Status < Dry::Struct
    attribute :key,         T::Symbol
    attribute :label,       T::String
    attribute :description, T::String

    def self.build key, label, description
      new key: key, label: label, description: description
    end
  end

  WillCall = Status.build(:will_call, 'Will Call', 'Tickets are at will call')
  Print    = Status.build(:to_print, 'To Print', 'You will need to print your tickets')
  Order    = Status.build(:to_order, 'To Order', 'You still need to order tickets')

  STATUSES = [ WillCall, Print, Order ].index_by(&:key)

  attribute :number, T::Int
  attribute :status, Status
end
