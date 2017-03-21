require 'rails_helper'

RSpec.describe Spotify::ClientBuilder do
  let(:repository) { Ticketron.container.repository }
  let(:http)       { instance_double HTTP }

  let(:user) { repository.user_for_email 'james@example.com', name: 'James' }

  let(:builder) { described_class.new repository: repository, http: http }

  it 'errors when unlinked' do
    expect do
      builder.call user
    end.to raise_error Spotify::NotLinked
  end

  it 'can use a valid token' do
    auth = Hashie::Mash.new credentials: { expires_at: 1.hour.from_now.to_i, token: 'token' }

    repository.attach_identity user: user, provider: Identity::Spotify, auth: auth

    client = builder.call user

    expect(client.access_token).to eq 'token'
  end

  it 'can refresh an old token' do
    auth = Hashie::Mash.new credentials: { expires_at: 1.hour.ago.to_i, refresh_token: 'refresh' }

    repository.attach_identity user: user, provider: Identity::Spotify, auth: auth

    expect(http).to receive(:call).and_return \
      'access_token'  => 'new_token',
      'refresh_token' => 'refresh',
      'expires_in'    => 3600,
      'scope'         => 'user-read-email'

    client = builder.call user

    expect(client.access_token).to eq 'new_token'
  end
end
