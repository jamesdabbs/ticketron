class Voice::Handlers::NotAuthed
  def call request
    Voice::Response.text "You'll need to link your account to do that"
  end
end
