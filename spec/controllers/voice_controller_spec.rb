require 'rails_helper'

RSpec.describe VoiceController do
  it 'can respond to a request' do
    inject voice: ->(_req) { Voice::Response.text 'Hello!' }

    get :home

    expect(response.status).to eq 200
    expect(json.speech).to eq 'Hello!'
  end

  it 'responds even on errors' do
    inject voice: ->(_req) { raise 'Oops' }

    get :home

    expect(response.status).to eq 400
    expect(json.error).to eq 'Oops'
  end
end
