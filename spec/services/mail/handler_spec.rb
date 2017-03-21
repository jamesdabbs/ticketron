require 'rails_helper'

RSpec.describe Mail::Handler do
  let(:repository) { instance_double Repository }
  let(:notifier)   { instance_double Notifier }
  let(:songkick)   { instance_double Songkick }

  let(:user)    { build :user }
  let(:concert) { build :concert }
  let(:mail)    { build :mail, user: user }

  let(:parsers) { [] }
  let(:handler) {
    described_class.new \
      parsers:    parsers,
      repository: repository,
      notifier:   notifier,
      songkick:   songkick
  }

  context 'with a parser' do
    let(:parsers) { [
      ->(_) {
        Mail::Parser::Result.new \
          concert: concert,
          tickets: 4,
          method:  Tickets::WillCall
      }
    ] }

    it 'can parse and record an email' do
      expect(repository).to receive(:add_tickets).with(
        user: user, concert: concert, tickets: 4, method: Tickets::WillCall)
      expect(notifier).not_to receive(:email_unhandled)

      expect(repository).to receive(:attach_concert).with(concert: concert, mail: mail)
      handler.call mail
    end
  end

  context 'failing to find concert' do
    let(:parsers) { [
      ->(_) { raise Songkick::ConcertNotFound }
    ] }

    it 'can fail to find a concert' do
      expect(notifier).to receive(:email_concert_not_found).with(email: mail)

      handler.call mail
    end
  end

  it 'can fail to handle a message' do
    expect(notifier).to receive(:email_unhandled).with(email: mail)

    handler.call mail
  end
end
