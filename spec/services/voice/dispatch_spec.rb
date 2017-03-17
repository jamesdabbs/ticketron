require 'rails_helper'

RSpec.describe Voice::Dispatch do
  it 'can route to a handler' do
    req      = build :request, action: 'foo'
    dispatch = described_class.new 'foo' => spy
    dispatch.call req

    expect(calls).to eq [[:call, req]]
  end

  it 'can fail to find a handler' do
    req      = build :request, action: 'foo'
    dispatch = described_class.new 'bar' => spy
    result   = dispatch.call req

    expect(calls).to eq []
    expect(result.speech).to eq "I don't know how to do that"
  end

  it 'can fail to authorize' do
    handler = ->(_) { raise Voice::Dispatch::UserNotFound }

    dispatch = described_class.new 'foo' => handler
    result   = dispatch.call build(:request, action: 'foo')
    expect(result.speech).to match(/you'll need to link/i)
  end
end
