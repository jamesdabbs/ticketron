module Voice
  class Request
    def initialize data
      @id, @timestamp, @lang, @result, @status, @session_id, @original_request = data.values_at :id, :timestamp, :lang, :result, :status, :sessionId, :originalRequest
    end

    def action
      fetch @result, :action
    end

    def parameters
      fetch @result, :parameters
    end

    def user_id
      fetch @original_request, :data, :user, :user_id
    end

    private

    def fetch init, *keys
      keys.reduce(init) { |h,k| h.fetch k }
    end
  end
end
