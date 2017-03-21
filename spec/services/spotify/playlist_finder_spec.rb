require 'rails_helper'

RSpec.describe Spotify::PlaylistFinder do
  let(:spotify)        { instance_double Spotify::Client }
  let(:repository)     { instance_double Repository }

  let(:finder) {
    Spotify::PlaylistFinder.new \
      repository:     repository,
      client_builder: ->(_) { spotify }
    }

  it 'can find a saved playlist' do
    playlist = build :playlist

    expect(repository).to receive(:spotify_playlist).and_return playlist

    expect(finder.call _).to eq playlist
  end

  it 'can find and record a playlist on spotify' do
    expect(repository).to receive(:spotify_playlist).exactly(2).times.and_return nil

    expect(spotify).to receive(:me).and_return('id' => 5)
    expect(spotify).to receive(:user_playlists).and_return \
      'items' => [
        { 'name' => 'Other thing', 'id' => 14 },
        { 'name' => 'Ticketron', 'id' => 15, 'external_urls' => {
            'spotify' => 'http://example.com/stuff'
        } }
      ]

    expect(repository).to receive(:update_spotify_playlist)

    finder.call _
  end

  it 'can create and record a new playlist' do
    expect(repository).to receive(:spotify_playlist).exactly(2).times.and_return nil

    expect(spotify).to receive(:me).and_return('id' => 5)
    expect(spotify).to receive(:user_playlists).and_return \
      'items' => [
         { 'name' => 'Other thing', 'id' => 14 },
       ]
    expect(spotify).to receive(:create_user_playlist).and_return \
      'name' => 'Ticketron',
      'id'   => 15,
      'external_urls' => {
        'spotify' => 'http://example.com/stuff'
      }

    expect(repository).to receive(:update_spotify_playlist)

    finder.call _
  end
end
