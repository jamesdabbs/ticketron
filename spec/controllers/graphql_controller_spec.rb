require 'rails_helper'

RSpec.describe GraphqlController do
  it 'can execute queries' do
    sign_in controller.repo.user_for_email 'test@example.com', name: 'Test'

    post :execute, params: { query: 'query { viewer { mail { from } } }'}

    expect(json['error']).to be nil
    expect(json['data']['viewer']['mail']).to eq []
  end

  it 'handles query errors' do
    sign_in controller.repo.user_for_email 'test@example.com', name: 'Test'

    post :execute, params: { query: 'query { notFound }' }

    expect(json['errors'].first['message']).to include "Field 'notFound' doesn't exist"
  end
end
