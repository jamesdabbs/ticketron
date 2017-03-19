class TicketsController < ApplicationController
  def update
    concert = repo.get_concert songkick_id: params[:concert_id]

    repo.add_tickets \
      user:    current_user,
      concert: concert,
      method:  Tickets::STATUSES.fetch(params[:status].to_sym)
    redirect_back fallback_location: concerts_path
  end
end
