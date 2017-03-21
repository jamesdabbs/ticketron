class DevController < ApplicationController
  # :nocov:
  InvalidEnv = Class.new StandardError

  before_action {
    raise InvalidEnv.new(Rails.env) unless Rails.env.development?
  }

  def force_login
    sign_in User.find params[:id]
    redirect_to '/'
  end
  # :nocov:
end
