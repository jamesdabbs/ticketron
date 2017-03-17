require 'rails_helper'

RSpec.describe Songkick::Scraper do
  let(:repository) { instance_double Repository }
  let(:songkick)   { Songkick::Scraper.new repository: repository }

  it 'can find concerts', :vcr do
    concert = songkick.find_concert venue: '9:30 Club', artists: ['Los Campesinos!', 'Crying']
    expect(concert.songkick_id).to eq '28528294'
    expect(concert.artists.map(&:name)).to eq ['Los Campesinos!', 'Crying']
    expect(concert.venue.name).to eq '9:30 Club'
  end

  it 'can fail to find concerts', :vcr do
    expect do
      songkick.find_concert venue: '9:30 Club', artists: ['Justin Bieber', 'Metallica']
    end.to raise_error Songkick::Scraper::ConcertNotFound
  end
end
