require 'rails_helper'

RSpec.describe Mail::Parser::Ticketfly do
  it 'can parse text' do
    mail = Mail.new \
      subject: 'Your Ticketfly Order',
      text:    File.read(Rails.root.join 'spec/fixtures/ticketfly.txt')

    result = described_class.new.call mail

    expect(result.venue).to eq '9:30 Club'
    expect(result.artists).to eq ['Los Campesinos!', 'Crying']
    expect(result.tickets).to eq 2
    expect(result.method.key).to eq :will_call
  end
end
