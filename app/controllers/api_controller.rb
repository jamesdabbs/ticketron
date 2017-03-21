class ApiController < ApplicationController
  before_action { request.format = :json }

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  rescue_from StandardError do |e|
    resp = { error: e }
    resp[:backtrace] = e.backtrace.map { |l| l.split('/gems/').last } if Rails.env.development?
    render json: resp, status: 400
  end
end
