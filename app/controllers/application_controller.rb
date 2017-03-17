class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def repo
    container.repository
  end

  def container
    Ticketron.container
  end
end
