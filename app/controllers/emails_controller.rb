class EmailsController < ApplicationController
  def create
    repo.claim_email user: current_user, email: params[:email]
    redirect_back fallback_location: profile_path
  end
end
