module Google
  class Calendar
    def initialize auth
      @client = Google::APIClient.new
      @client.authorization.access_token  = auth.credentials.token
      @client.authorization.refresh_token = auth.credentials.refresh_token
      @client.authorization.client_id     = Figaro.env.google_client_id!
      @client.authorization.client_secret = Figaro.env.google_client_secret!
      @client.authorization.refresh!

      @service = client.discovered_api 'calendar', 'v3'
    end

    def list_calendars
      run service.calendar_list.list
    end

    def insert_calendar name
      run service.calendars.insert, body: { summary: name }
    end

    def list_events calendar_id
      run service.events.list, params: { calendarId: calendar_id }
    end

    def insert_event calendar_id, event
      run service.events.insert, params: { calendarId: calendar_id }, body: event
    end

    private

    attr_reader :client, :service

    def run method, params: nil, body: nil
      options = { api_method: method }
      options[:parameters] = params if params
      if body
        options[:headers] = { 'Content-Type' => 'application/json' }
        options[:body]    = body.to_json
      end

      response = client.execute options
      unless response.success?
        raise "Google: #{response.status}"
      end
      JSON.parse response.body
    end
  end
end
