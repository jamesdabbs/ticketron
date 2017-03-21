require 'rails_helper'

RSpec.describe Spotify::Login do
  let(:repository) { Ticketron.container.repository }
  let(:login)      { described_class.new repository: repository }

  let(:auth) {
    Hashie::Mash.new \
      info: {
        email: 'user@example.com',
        name:  'User Name'
      }
  }

  it 'can create a user' do
    user = login.call auth: auth
    expect(user.name).to eq 'User Name'
  end

  it 'can find a user' do
    old_user = repository.user_for_email 'user@example.com', name: 'Old Name'

    user = login.call auth: auth

    expect(user).to eq old_user
  end
end
