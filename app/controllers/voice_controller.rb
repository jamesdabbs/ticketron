class VoiceController < ApiController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def home
    result = container.voice.call Voice::Request.from_params params
    render json: result
  rescue => e
    render json: { error: e }, status: 400
  end
end
