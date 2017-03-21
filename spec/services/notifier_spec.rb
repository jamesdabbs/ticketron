require 'rails_helper'

RSpec.describe Notifier do
  let(:mail) { build :mail }

  it 'unhandled emails' do
    expect(TicketMailer).to receive(:email_unhandled).with(email: mail)

    subject.email_unhandled email: mail
  end

  it 'concert not found' do
    expect(TicketMailer).to receive(:email_concert_not_found).with(email: mail)

    subject.email_concert_not_found email: mail
  end
end
