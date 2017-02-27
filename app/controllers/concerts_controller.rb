class ConcertsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    scope = if current_user
      current_user.concerts
    else
      Concert.all
    end

    @concerts = scope.order(at: :asc).includes :venue, :artists
  end
end
