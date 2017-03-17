class ConcertsController < ApplicationController
  def index
    @concerts = Ticketron.container.repository.upcoming_concerts user: current_user
  end

  def create
    if id = params[:concert][:songkick_id]
      Songkick::Scraper.new(user: current_user).import id
    else
      flash[:error] = 'You must provide a URL or ID'
    end
    redirect_to :back
  end
end
