require 'rails_helper'

RSpec.describe Mail::Handler do
  let(:repository) { instance_double Repository }
  let(:notifier)   { instance_double Notifier }
  let(:songkick)   { instance_double Songkick::Scraper }

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
          venue:   build(:venue),
          artists: [build(:artist)],
          tickets: 4,
          method:  Tickets::WillCall
      }
    ] }

    it 'can parse and record an email' do
      expect(songkick).to receive(:search).and_return(concert)

      expect(repository).to receive(:add_tickets).with(
        user: user, concert: concert, tickets: 4, method: Tickets::WillCall)
      expect(notifier).not_to receive(:email_unhandled)

      expect(repository).to receive(:attach_concert).with(concert: concert, mail: mail)
      handler.call mail
    end

    it 'can fail to find a concert' do
      expect(songkick).to receive(:search).and_raise(Songkick::Scraper::ConcertNotFound)
      expect(notifier).to receive(:email_concert_not_found).with(email: mail)

      handler.call mail
    end
  end

  it 'can fail to handle a message' do
    expect(notifier).to receive(:email_unhandled).with(email: mail)

    handler.call mail
  end
end
