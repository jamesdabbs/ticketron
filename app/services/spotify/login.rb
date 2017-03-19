class Spotify::Login < Gestalt[:repository]
  def call id
    email = id.data['info']['email']
    name  = id.data['info']['name']

    user = repository.ensure_user email: email, default_name: name

    repository.attach_identity user: user, identity: id

    user
  end
end
