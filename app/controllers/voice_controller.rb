class VoiceController < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def home
    result = Voice::Dispatch.new.call Voice::Request.new params
    render json: result
  end
end
