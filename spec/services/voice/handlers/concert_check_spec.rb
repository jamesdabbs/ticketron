require 'rails_helper'

RSpec.describe Voice::Handlers::ConcertCheck do
  let(:user)       { build :user }
  let(:repository) { instance_double Repository, user_for_voice_request: user }

  let(:concert_finder) {
    ->(_) {
      build :concert,
        artists: [build(:artist, name: 'Run the Jewels')],
        at:      Date.parse('May 15')
    }
  }

  let(:handler) { described_class.new repository: repository, concert_finder: concert_finder }

  it 'can describe a concert' do
    expect(repository).to receive(:tickets_status).and_return Tickets::Print

    response = handler.call build(:request, params: { concert: 'floop' })

    expect(response.speech).to include 'Run the Jewels'
    expect(response.speech).to include 'May 15th'
    expect(response.speech).to match(/print your tickets/i)
  end
end
