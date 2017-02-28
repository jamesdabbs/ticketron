class Voice::Handlers::NotFound
  def call request
    Voice.simple_response "I don't know how to do that"
  end
end
