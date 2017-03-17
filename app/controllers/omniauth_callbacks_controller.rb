class AuthCallbacksController < Devise::OmniauthCallbacksController
  def spotify
    user = User.from_spotify auth: request.env['omniauth.auth']
    sign_in user
    redirect_to '/', success: 'Signed in with Spotify'
  end

  def google_oauth2
    auth = request.env['omniauth.auth']

    id = Identity.where(provider: 'google_oauth2', uid: auth.uid).first_or_intitialize
    id.data = auth.to_h
    id.save!

    redirect_to '/', success: 'Thanks for linking your Google account'
  end

  def logout
    sign_out
    redirect_to '/', success: 'You have been logged out'
  end

  def after_omniauth_failure_path_for scope
    '/'
  end
end
