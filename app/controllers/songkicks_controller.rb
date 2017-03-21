class SongkicksController < ApplicationController
  def update
    repo.update_songkick user: current_user, username: params[:username]

    redirect_back fallback_location: profile_path
  end
end
