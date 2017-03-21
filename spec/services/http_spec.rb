require 'rails_helper'

RSpec.describe HTTP do
  it 'can make a call', :vcr do
    response = subject.call :get, 'http://ip.jsontest.com'
    expect(response['ip']).to be_present
  end

  it 'can fail to make call', :vcr do
    expect do
      subject.call :get, 'http://example.com/error'
    end.to raise_error HTTP::Error, /404/
  end
end
