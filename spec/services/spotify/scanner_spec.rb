require 'rails_helper'

RSpec.describe Spotify::Scanner do
  Given(:client) do
    instance_double(Spotify::Client).tap do |c|
      expect(c).to receive(:search).and_return(results)
    end
  end
  Given(:scanner) { described_class.new repository: spy }
  Given(:artist)  { build :artist, name: 'Floop' }


  When { scanner.call artists: [artist], spotify: client }

  context 'one match' do
    Given(:results) {
      {
        'artists' => {
          'items' => [
            { 'name' => 'Floop!', 'id' => '17' }
          ]
        }
      }
    }

    Then { calls.first == [:update_spotify_id, { artist: artist, spotify_id: '17' }] }
  end

  context 'multiple results' do
    Given(:results) {
      {
        'artists' => {
          'items' => [
            { 'name' => 'Flam', 'id' => '12' },
            { 'name' => 'Floop!', 'id' => '13' }
          ]
        }
      }
    }

    Then { calls.first == [:update_spotify_id, { artist: artist, spotify_id: '13' }] }
  end

  context 'bad results' do
    Given(:results) {
      {
        'artists' => {
          'items' => [
            { 'name' => 'Whizz', 'id' => '12' },
            { 'name' => 'Bang', 'id' => '13' }
          ]
        }
      }
    }

    Then { calls == [] }
  end
end
