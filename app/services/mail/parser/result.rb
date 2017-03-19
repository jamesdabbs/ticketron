module Mail
  module Parser
    class Result < Dry::Struct
      attribute :venue,   T::String
      attribute :artists, T::Array.member(T::String)
      attribute :tickets, T::Int
      attribute :method,  Tickets::Status
    end
  end
end
