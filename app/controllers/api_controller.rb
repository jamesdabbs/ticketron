class ApiController < ApplicationController
  before_action { request.format = :json }
end
