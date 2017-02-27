class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def spotify
    user = User.from_spotify auth: request.env['omniauth.auth']
    sign_in user
    redirect_to '/', success: 'Signed in with Spotify'
  end
end
