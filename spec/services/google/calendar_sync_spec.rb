require 'rails_helper'

RSpec.describe Google::CalendarSync do
  let(:user)    { build :user }
  let(:concert) { build :concert }

  let(:calendar)   { instance_double Google::Calendar }
  let(:repository) { instance_double Repository }

  let(:sync) {
    described_class.new \
      repository:     repository,
      build_calendar: ->(_) { calendar }
  }

  it 'can create a calendar' do
    expect(repository).to receive(:find_auth).and_return({})

    expect(calendar).to receive(:list_calendars).and_return []
    expect(calendar).to receive(:insert_calendar).with 'Ticketron'
    expect(calendar).to receive(:list_calendars).and_return [{
      'summary' => 'Ticketron', 'id' => 7
    }]

    expect(calendar).to receive(:list_events).and_return []

    expect(repository).to receive(:upcoming_concerts).and_return [concert]

    expect(calendar).to receive(:insert_event) do |id, params|
      expect(id).to eq 7
      expect(params[:location]).to eq concert.venue.name
    end

    expect(repository).to receive(:google_calendar_synced)

    sync.call user: user
  end
end
