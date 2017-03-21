class Spotify::Login < Gestalt[:repository]
  def call auth:
    email = auth['info']['email']
    name  = auth['info']['name']

    user = repository.user_for_email email, name: name

    repository.attach_identity user: user, provider: Identity::Spotify, auth: auth
    repository.update_spotify  user: user, user_id: auth.uid

    user
  end
end
