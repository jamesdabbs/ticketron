module Voice
  class Dispatch
    UserNotFound = Class.new StandardError

    def initialize handlers={}
      @handlers   = handlers
      @not_found  = Handlers::NotFound.new
      @not_authed = Handlers::NotAuthed.new
    end

    def call request
      handler = @handlers.fetch request.action, @not_found
      handler.call request
    rescue Voice::Dispatch::UserNotFound
      @not_authed.call request
    end
  end
end
