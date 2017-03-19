class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    @spotify  = repo.identity user: @user, provider: 'spotify'
    @playlist = container.spotify_playlist_finder.call @user

    @google  = repo.identity user: @user, provider: 'google_oauth2'
  end
end
