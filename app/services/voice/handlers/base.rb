class Voice::Handlers::Base
  include ActionView::Helpers::TextHelper

  def user_for request
    User.find_by google_user_id: request.user_id
  end

  def simple_response text
    Voice.simple_response text
  end
end
