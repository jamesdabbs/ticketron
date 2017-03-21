require 'rails_helper'

RSpec.describe Songkick do
  #let(:remote)     { instance_double Songkickr::Remote }
  let(:remote)     { Songkick.build.remote }
  let(:repository) { Repository.new }

  let(:songkick) { described_class.new remote: remote, repository: repository }

  it 'can find a venue' do
    expect(remote).to receive(:venue_search).and_return \
      Hashie::Mash.new(results: [{ id: 922, display_name: '9:30 Club'}])

    venue = songkick.find_venue '9:30'

    expect(venue.songkick_id).to eq '922'
    expect(venue.name).to eq '9:30 Club'
  end

  it 'can find a concert' do
    expect(remote).to receive(:artist_search).with('Daughters').and_return \
      Hashie::Mash.new(results: [{ id: 386957 }])

    expect(remote).to receive(:artist_events).
      with(386957, min_date: '2017-06-04', max_date: '2017-06-04').
      and_return Hashie::Mash.new(results: [{
      venue: { display_name: '9:30 Club' },
      performances: [
        { display_name: 'Daughters' }
      ]
      }])

    concert = songkick.find_concert \
      artists: ['Daughters'],
      venue:   '9:30 Club',
      date:    Date.parse('04 June 2017')

    expect(concert.venue.name).to eq '9:30 Club'
    expect(concert.artists.first.name).to eq 'Daughters'
  end

  it 'can fail to find a concert' do
    expect(remote).to receive(:artist_search).with('Daughters').and_return \
      Hashie::Mash.new(results: [{ id: 386957 }])

    expect(remote).to receive(:artist_events).
      and_return Hashie::Mash.new(results: [])

    expect do
      songkick.find_concert artists: ['Daughters'], venue: '9:30 Club', date: 10.days.from_now
    end.to raise_error Songkick::ConcertNotFound
  end
end
