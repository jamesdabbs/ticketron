Doorkeeper::Application.first_or_create! \
  name:         'Google',
  uid:          Figaro.env.google_client_id!,
  secret:       Figaro.env.google_client_secret!,
  redirect_uri: "https://oauth-redirect.googleusercontent.com/r/#{Figaro.env.google_project_id!}"
