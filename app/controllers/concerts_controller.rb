class ConcertsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    scope = if current_user
      current_user.concerts
    else
      Concert.all
    end

    @concerts = scope.order(at: :asc).includes :venue, :artists

    if current_user
      @attends = current_user.
                   concert_attendees.
                   where(concert: @concerts).
                   index_by(&:concert_id)
    end
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
