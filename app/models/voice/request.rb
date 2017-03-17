module Voice
  class Request < Dry::Struct
    attribute :id,        T::String
    attribute :timestamp, T::String
    attribute :result,    Object
    attribute :request,   Object

    def self.from_params data
      # lang:       data[:lang],
      # status:     data[:status],
      # session_id: data[:sessionId],
      new \
        id:         data[:id],
        timestamp:  data[:timestamp],
        result:     data[:result],
        request:    data[:originalRequest]
    end

    def action
      result.fetch(:action)
    end

    def params
      result[:parameters]
    end

    def user_id
      request.fetch(:data).fetch(:user).fetch(:user_id)
    end
  end
end
