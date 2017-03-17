class UsersController < ApplicationController
  def show
    @user     = repo.user_by_spotify_id params[:id]
    @concerts = repo.upcoming_concerts user: @user
  end
end
