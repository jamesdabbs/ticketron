class TicketsController < ApplicationController
  def update
    concert  = Concert.find params[:concert_id]
    attendee = current_user.concert_attendees.find_by concert: concert
    attendee.set_status params[:status]
    redirect_to :back
  end
end
