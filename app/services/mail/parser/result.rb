module Mail
  module Parser
    class Result < Dry::Struct
      attribute :concert, Concert
      attribute :tickets, T::Int
      attribute :method,  Tickets::Status
    end
  end
end
