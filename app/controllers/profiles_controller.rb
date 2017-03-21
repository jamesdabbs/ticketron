class ProfilesController < ApplicationController
  def show
    @user = current_user.to_model
  end
end
