class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def home
    result = Ticketron.container.voice.call Voice::Request.from_params params
    render json: result
  rescue => e
    render json: { error: e, backtrace: e.backtrace }, status: 400
  end
end
