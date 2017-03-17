require 'rails_helper'

RSpec.describe Mail::Handler do
  let(:repository) { instance_double Repository }
  let(:notifier)   { instance_double Notifier }
  let(:songkick)   { instance_double Songkick::Scraper }

  let(:user)    { build :user }
  let(:concert) { build :concert }
  let(:mail)    { build :mail }

  let(:default) {
    described_class.new \
      parsers:    [],
      repository: repository,
      notifier:   notifier,
      songkick:   songkick
  }

  it 'can parse and record an email' do
    parser = ->(_) {
      Mail::Parser::Result.new \
        venue:   build(:venue),
        artists: [build(:artist)],
        tickets: 4,
        method:  Tickets::WillCall
    }

    handler = default.with(parsers: [parser])

    expect(repository).to receive(:user_by_email).and_return(user)
    expect(songkick).to receive(:find_concert).and_return(concert)

    expect(repository).to receive(:add_tickets).with(
      user: user, concert: concert, tickets: 4, method: Tickets::WillCall)
    expect(notifier).not_to receive(:email_unhandled)

    expect(repository).to receive(:attach_concert).with(concert: concert, mail: mail)
    handler.call mail
  end

  it 'can fail to parse an email' do
    expect(repository).to receive(:user_by_email).and_return(user)
    expect(notifier).to receive(:email_unhandled).with(user: user, email: mail)

    default.call mail
  end

  it 'can fail to find a user' do
    expect(repository).to receive(:user_by_email).and_raise(Repository::UserNotFound)
    expect(notifier).to receive(:email_account_not_found).with(email: mail)

    default.call mail
  end

  it 'can fail to find a concert' do
    parser = ->(_) {
      Mail::Parser::Result.new \
        venue:   '...',
        artists: ['...'],
        tickets: 4,
        method:  Tickets::WillCall
    }

    handler = default.with parsers: [parser]

    expect(repository).to receive(:user_by_email).and_return(user)
    expect(songkick).to receive(:find_concert).and_raise(Songkick::Scraper::ConcertNotFound)
    expect(notifier).to receive(:email_concert_not_found).with(user: user, email: mail)

    handler.call mail
  end
end
