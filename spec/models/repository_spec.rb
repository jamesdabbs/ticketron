require 'rails_helper'

RSpec.shared_examples 'repository' do
  let(:concert) { build :concert }
  let(:venue)   { concert.venue }

  let(:user) do
    subject.user_for_email 'floop@example.com', name: 'Floop'
  end

  context 'users' do
    context 'oauth' do
      let(:token) { SecureRandom.hex 16 }
      let(:request) {
        build :request, request: {
          'data' => {
            'user' => {
              'access_token' => token
            }
          }
        }
      }

      it 'can lookup users for voice requests' do
        expect(Doorkeeper::AccessToken).to receive(:by_token).with(token).and_return \
          OpenStruct.new resource_owner_id: user.id

        expect(subject.user_for_voice_request request).to eq user
      end

      it 'can fail to find users for voice requests' do
        expect(Doorkeeper::AccessToken).to receive(:by_token).with(token).and_return nil

        expect(subject.user_for_voice_request request).to eq nil
      end

      it 'can attach identity data' do
        auth = { 'foo' => 'bar' }

        subject.attach_identity user: user, provider: 'test', auth: auth

        expect(subject.find_auth user: user, provider: 'test').to eq auth
      end

      it 'can update credentials'
    end
  end

  describe 'venue' do
    it 'can create a venue' do
      v = subject.ensure_venue songkick_id: id, name: 'Black Cat'
      expect(v.name).to eq 'Black Cat'
    end
  end

  describe 'concerts' do
    it 'can list upcoming concerts for a group' do
      concerts = 3.times.map { build :concert }
      users    = 2.times.map do |i|
        subject.user_for_email "user#{i}@example.com", name: i
      end

      concerts.each { |c| subject.ensure_concert c }
      users.zip(concerts).each do |u,c|
        subject.add_tickets \
          user:    u,
          concert: c,
          tickets: 1,
          method:  Tickets::WillCall
      end

      expect(subject.upcoming_concerts(users: [users.first]).count).to eq 1
      expect(subject.upcoming_concerts(users: users).count).to eq 2
    end
  end

  describe 'tickets' do
    it 'can add and check user tickets' do
      subject.ensure_concert concert

      method = Tickets::STATUSES.values.sample
      subject.add_tickets \
        user:    user,
        concert: concert,
        tickets: 5,
        method:  method

      status = subject.tickets_status user: user, concert: concert
      expect(status).to eq method
    end
  end

  describe 'mail' do
    it 'can pull mail from a user' do
      user

      m = subject.save_mail(build :mail, from: 'floop@example.com')

      subject.save_mail(build :mail)

      expect(subject.mail_from m.user).to eq [m]
    end
  end

  describe 'spotify' do
    it 'can set metadata' do
      subject.update_spotify_playlist user: user,
        user_id: 1, id: 2, url: 'http://example.com', synced: Time.now

      playlist = subject.spotify_playlist user: user
      expect(playlist.url).to eq 'http://example.com'
    end
  end

end

RSpec.describe Repository do
  it_behaves_like 'repository'
end

other_repositories = []
other_repositories.each do |repository|
  RSpec.describe Repository::Memory do
    it_behaves_like 'repository'

    methods = repository.instance_methods(false).sort

    it 'shares the same public API' do
      expect(methods).to eq Repository.instance_methods(false).sort
    end

    methods.each do |name|
      it "has the same signature for `#{name}`" do
        db   = Repository.instance_method name
        repo = repository.instance_method name
        expect(repo.parameters).to eq db.parameters
      end
    end
  end
end
