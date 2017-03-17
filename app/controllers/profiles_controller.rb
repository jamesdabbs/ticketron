class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @mail = repo.mail_from @user

    @grants = Doorkeeper::AccessGrant.
                where(resource_owner_id: current_user.id).
                includes(:application)
    @identities = Identity.where(user: current_user)
  end
end
