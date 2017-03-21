class VoiceController < ApiController
  def home
    # FIXME: need to verify sender authenticity
    result = container.voice.call Voice::Request.from_params params
    render json: result
  end
end
