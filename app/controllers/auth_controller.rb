class AuthController < Devise::OmniauthCallbacksController
  def spotify
    id = Identity.oauthorized request.env['omniauth.auth'], user: current_user
    user = container.spotify_login.call id

    sign_in user
    redirect_to profile_path, success: 'Signed in with Spotify'
  end

  def google_oauth2
    Identity.oauthorized request.env['omniauth.auth'], user: current_user
    redirect_to '/', success: 'Thanks for linking your Google account'
  end

  def login
  end

  def logout
    sign_out
    redirect_to '/', success: 'You have been logged out'
  end

  def after_omniauth_failure_path_for scope
    '/'
  end
end
