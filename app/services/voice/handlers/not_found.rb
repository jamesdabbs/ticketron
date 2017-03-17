class Voice::Handlers::NotFound
  def call request
    Voice::Response.text "I don't know how to do that"
  end
end
