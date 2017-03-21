require 'rails_helper'

RSpec.describe Mail::Parser::Ticketfly do
  let(:concert)  { build :concert }
  let(:songkick) { instance_double Songkick }

  it 'can parse text' do
    mail = build :mail,
      subject: 'Your Ticketfly Order',
      text:    File.read(Rails.root.join 'spec/fixtures/ticketfly.txt')

    expect(songkick).to receive(:find_concert).with(
      venue:   '9:30 Club',
      artists: ['Los Campesinos!', 'Crying'],
      date:    Date.parse('March 09 2017')
    ).and_return concert

    result = described_class.new(songkick: songkick).call mail

    expect(result.concert).to eq concert
    expect(result.tickets).to eq 2
    expect(result.method.key).to eq :will_call
  end
end
