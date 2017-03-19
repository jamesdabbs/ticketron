class DevController < ApplicationController
  before_action {
    raise "Attempting to use DevController in #{Rails.env}" unless Rails.env.development?
  }

  def force_login
    sign_in User.find params[:id]
    redirect_to '/'
  end
end
