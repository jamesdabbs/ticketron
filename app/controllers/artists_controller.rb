class ArtistsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # TODO: only artists that I track
    @artists = Artist.all
  end

  def show
    @artist = Artist.find params[:id]
  end

  def lookup_spotify_id
    Spotify::Scanner.new(current_user).lookup_artists Artist.where(spotify_id: nil)
    redirect_to :back
  end
end
