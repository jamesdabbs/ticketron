require 'rails_helper'

RSpec.describe Spotify::PlaylistGenerator do
  let(:repository) { instance_double Repository }
  let(:scanner)    { instance_double Spotify::Scanner }

  let(:playlist)   { build :playlist }
  let(:spotify)    { instance_double Spotify::Client }

  let(:generator) {
    described_class.new \
      repository:     repository,
      scanner:        scanner,
      client_builder: ->(_) { spotify },
      finder:         ->(_) { playlist }
  }

  it 'can build a playlist' do
    user     = build :user
    concerts = 5.times.map { build :concert }

    expect(repository).to receive(:upcoming_concerts).
      at_least(1).times.
      and_return concerts

    expect(spotify).to receive(:artist_top_tracks).
      exactly(5).times.
      and_return 'tracks' => [{'uri' => id}]

    expect(spotify).to receive(:add_user_tracks_to_playlist) do |uid, pid, uris|
      expect(uid).to eq playlist.user_id
      expect(pid).to eq playlist.id
      expect(uris.length).to eq 5
    end

    expect(repository).to receive(:update_spotify_playlist)

    generator.call user: user
  end

  it "doesn't scan unless it needs to" do
    user = build :user

    expect(repository).to receive(:upcoming_concerts).
      at_least(1).times.
      and_return [build(:concert)]

    expect(spotify).to receive(:artist_top_tracks).and_return 'tracks' => [{'uri' => id}]
    expect(spotify).to receive(:add_user_tracks_to_playlist).and_return false

    expect do
      generator.call user: user
    end.to raise_error Spotify::AddingFailed
  end

  it 'auto-scans when needed' do
    user    = build :user
    artist  = build :artist, spotify_id: nil
    concert = build :concert, artists: [artist]

    expect(repository).to receive(:upcoming_concerts).and_return [concert]
    expect(repository).to receive(:upcoming_concerts).and_return []

    expect(scanner).to receive(:call).with(spotify: spotify, artists: concert.artists)

    expect(repository).to receive(:update_spotify_playlist)

    generator.call user: user
  end
end
