require 'rails_helper'

RSpec.describe Repository do
  let(:user) { User.create! email: 'floop@example.com' }
  let(:venue) { DB::Venue.create! }
  let(:concert) { DB::Concert.create! venue: venue, at: 1.month.from_now }

  it 'can find users by email' do
    u = subject.user_by_email "Floop R Pig <#{user.email}>"
    expect(u).to eq user
  end

  it 'can add and check user tickets' do
    method = Tickets::STATUSES.values.sample
    subject.add_tickets \
      user:    user,
      concert: concert,
      tickets: 5,
      method:  method

    status = subject.tickets_status user: user, concert: concert

    expect(method).to eq status
  end

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
  end

  describe 'concerts' do
    before(:each) {
      DB::ConcertAttendee.create! \
        user: user, concert: concert, number: 4, status: Tickets::Print
    }

    it 'can list upcoming' do
      concerts = subject.upcoming_concerts user: user
      expect(concerts.count).to eq 1
      expect(concerts.first.at).to eq concert.at
      expect(concerts.first.tickets.status).to eq Tickets::Print
    end

    it 'can find others in a month' do
      concert = subject.next_concert_for user: user
      others  = subject.other_upcoming user: user, concert: concert
      expect(others).to eq []
      expect(concert).not_to be nil
    end

    it 'can fuzzy match by name' do # see ConcertResolver
      artist = DB::Artist.create! name: 'Why?'
      DB::ConcertArtist.create! artist: artist, concert: concert

      concert = subject.concert_by_name user: user, name: 'why'
      expect(concert).not_to be nil
    end
  end
end
