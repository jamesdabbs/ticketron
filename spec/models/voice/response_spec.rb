require 'rails_helper'

RSpec.describe Voice::Response do
  it 'can convert to JSON' do
    json   = described_class.text('Hello, World').to_json
    parsed = JSON.parse json

    expect(parsed['speech']).to eq "Hello, World"
    expect(parsed['displayText']).to eq "Hello, World"
  end
end
