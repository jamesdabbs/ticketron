class VoiceController < ApplicationController
  include ActionView::Helpers::TextHelper

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def home
    Rails.logger.info params.to_s
    Rails.logger.info request.body.read.to_s

    concert = Concert.upcoming.first
    artists = concert.artists.map(&:name)

    month = concert.at.strftime '%B'
    day   = concert.at.strftime('%d').to_i.ordinalize

    text = "Your next concert is #{artists.to_sentence} at #{concert.venue.name} on #{month} #{day}."

    others = Concert.in_month(concert.at).count
    if others > 0
      text += " You have #{pluralize others, 'other concert'} in #{month}."
    end


    render json: {
      source: "ticketron",
      speech: text,
      displayText: text,
      data: {
        google: {
          expect_user_response: false,
          is_ssml: false
        }
      }
    }
  end
end
