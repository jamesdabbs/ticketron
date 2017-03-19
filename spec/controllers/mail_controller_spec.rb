require 'rails_helper'

RSpec.describe MailController do
  context 'create' do
    it 'can respond' do
      inject mail_receiver: ->(_) {}

      post :create

      expect(response.status).to eq 200
    end

    it 'can handle errors' do
      inject mail_receiver: ->(_) { raise 'error' }

      post :create

      expect(response.status).to eq 200
    end
  end
end
