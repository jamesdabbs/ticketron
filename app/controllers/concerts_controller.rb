class ConcertsController < ApplicationController
  def index
    @concerts = repo.upcoming_concerts user: current_user
  end

  def create
    if id = params[:concert][:songkick_id]
      container.songkick.import id
    else
      flash[:error] = 'You must provide a URL or ID'
    end
    redirect_to :back
  end
end
