class Tickets < Dry::Struct
  class Status < Dry::Struct
    attribute :key,         T::Symbol
    attribute :label,       T::String
    attribute :description, T::String

    def self.build key, label, description
      new key: key, label: label, description: description
    end
  end

  Order    = Status.build(:to_order, 'To Order', 'You still need to order tickets')
  ByMail   = Status.build(:by_mail, 'By Mail', 'Your tickets will be mailed to you')
  InHand   = Status.build(:in_hand, 'In Hand', 'Your tickets are ready')
  Print    = Status.build(:to_print, 'To Print', 'You will need to print your tickets')
  WillCall = Status.build(:will_call, 'Will Call', 'Tickets are at will call')

  STATUSES = [Order, ByMail, Print, InHand, WillCall].index_by(&:key)

  attribute :user,   Object
  attribute :number, T::Int
  attribute :status, Status
end
